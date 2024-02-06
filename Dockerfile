################################################################
### Base
################################################################
FROM ruby:3.2.2-alpine3.18 as base
WORKDIR /app

# Install required alpine packages
RUN apk update \
    && apk add --no-cache \
    bash \
    build-base \
    ca-certificates \
    coreutils \
    curl \
    gcompat \
    ghostscript \
    git \
    gnupg \
    imagemagick \
    libffi-dev \
    libpq-dev \
    libxml2 \
    libxslt \
    make \
    nodejs \
    openssl1.1-compat \
    postgresql-client \
    shared-mime-info \
    tzdata \
    npm \
    vips \
    yarn

# ADD GOC-GDC TLSi gateway crt to ca-certificates
# COPY ./.certs/GOC-GDC-ROOT-A.crt /app/.certs/GOC-GDC-ROOT-A.crt
# RUN cp /app/.certs/GOC-GDC-ROOT-A.crt /usr/local/share/ca-certificates/GOC-GDC-ROOT-A.crt \
#     && update-ca-certificates

################################################################
## Development
################################################################
FROM base as development

ARG USERNAME=hangardev
ARG GROUPNAME=$USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# add ssh for development / git access and sudo for root commands
RUN apk update \
    && apk add --no-cache openssh \
    sudo

WORKDIR /app
ENV RAILS_ENV=development
ENV SECRET_KEY_BASE=1

# add user hangar
RUN addgroup --gid $USER_GID -S $GROUPNAME  \
    && adduser -G $GROUPNAME --shell /bin/bash --disabled-password --uid $USER_GID $USERNAME

# add default sudo role for permissive access in dev
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# copy over development scripts to profile / load on login
COPY dx.sh /etc/profile.d/dx.sh

# copy over our custom bashrc that loads dx.sh
COPY ./docker/bashrc /home/hangardev/.bashrc

# create a volume mount point with the right permissions for node packages, storage and tmp files
RUN install -d -m 0755 -o $USERNAME -g $GROUPNAME /app/node_modules
RUN install -d -m 0755 -o $USERNAME -g $GROUPNAME /app/storage
RUN install -d -m 0755 -o $USERNAME -g $GROUPNAME /app/tmp

# log the image build date
RUN echo "hangar-app="$(date +"%Y-%m-%d %H:%M %Z") >> /DOCKER_IMAGE_BUILD_HISTORY

# Expose Puma port
EXPOSE 3000

# user 1000 for WSL types
USER 1000

# use bash
ENV SHELL /bin/bash

################################################################
### Builder
################################################################
FROM base as builder
WORKDIR /app

ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=1

# Copy the application files, will be owned by the root user!
COPY . /app/

# Don't need to ship the docker files with the image
RUN rm -rf /app/docker

# install yarn
RUN yarn install

# exclude development and test packages
RUN gem install bundler \
    && bundle config --local frozen 1 \
    && bundle config --local deployment true \
    && bundle config --local without "development test" \
    && bundle config set path /app/vendor/bundle \
    && bundle install -j4 --retry 3 \
    && bundle exec rails assets:precompile \
    && bundle exec rails assets:clean \
    && bundle clean

# remove node_modules that were only needed for assets:precompile
RUN rm -rf /app/node_modules

################################################################
### Production
################################################################
FROM base
WORKDIR /app

# default option to disable the creation of a home directory, can be null'd out to support
# a scenario where the home directory needs to exist and be writable (i.e. vs code remote container)
ARG HOME_DIRECTORY_OPT=-H

# Set environment as production
ENV RAILS_ENV production

# copy files from builder (app and gems)
COPY --from=builder /app/. /app/
COPY --from=builder /usr/local/bundle/. /usr/local/bundle

# add user hangar
RUN addgroup --gid 1001 -S hangar  \
    && adduser -G hangar --shell /bin/false --disabled-password $HOME_DIRECTORY_OPT --uid 1001 hangar

# tmp must be writable by the app user
RUN chown -R hangar:hangar /app/tmp

# log the image build date
RUN echo "hangar-app="$(date +"%Y-%m-%d %H:%M %Z") >> /DOCKER_IMAGE_BUILD_HISTORY

EXPOSE 3000

USER 1001
ENTRYPOINT ["/bin/bash", "/app/boot-app.sh"]
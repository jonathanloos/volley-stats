# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Set production environment
ENV BUNDLE_PATH="/usr/local/bundle" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true"
    
# Rails app lives here
WORKDIR /rails

################################################################
## Development
################################################################
FROM base as development

ARG USERNAME=volleydev
ARG GROUPNAME=$USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client libpq-dev nodejs git sudo build-essential bison openssl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev autoconf libc6-dev ncurses-dev automake libtool

WORKDIR /rails
ENV RAILS_ENV=development
ENV SECRET_KEY_BASE=1

# add user rails
RUN addgroup --gid $USER_GID --system $GROUPNAME  \
    && adduser --ingroup $GROUPNAME --shell /bin/bash --disabled-password --uid $USER_GID $USERNAME

# add default sudo role for permissive access in dev
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# create a volume mount point with the right permissions for node packages, storage and tmp files
# RUN install -d -m 0755 -o $USERNAME -g $GROUPNAME /rails/node_modules
# RUN install -d -m 0755 -o $USERNAME -g $GROUPNAME /rails/storage
RUN install -d -m 0755 -o $USERNAME -g $GROUPNAME /tmp

# # Run and own only the runtime files as a non-root user for security
# RUN useradd rails --create-home --shell /bin/bash

RUN echo "hangar-app="$(date +"%Y-%m-%d %H:%M %Z") >> /DOCKER_IMAGE_BUILD_HISTORY

EXPOSE 3000

USER 1000

ENV SHELL /bin/bash

################################################################
## Builder
################################################################
# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config nodejs

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

################################################################
## Production
################################################################
# Final stage for app image
FROM base

ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development" \
    BUNDLE_DEPLOYMENT="1"

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/bin/bash", "/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]

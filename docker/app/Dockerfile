# https://medium.com/firehydrant-io/developing-a-ruby-on-rails-app-with-docker-compose-d75b20334634
FROM ruby:3.2.2-alpine3.17 as base
# WORKDIR /app

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

# Expose Puma port
EXPOSE 3000
EXPOSE 1234
EXPOSE 26162

# Save timestamp of image building
RUN date -u > BUILD_TIME
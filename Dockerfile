FROM ubuntu:22.04

ARG FLUTTER_VERSION=stable

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
ENV PUB_CACHE=/root/.pub-cache

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip \
    clang cmake ninja-build pkg-config \
    libgtk-3-dev liblzma-dev libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
    --branch ${FLUTTER_VERSION} \
    --depth 1

RUN flutter precache --linux && flutter --version

WORKDIR /app

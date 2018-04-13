FROM docker:dind
LABEL maintainer "Florian Dambrine <android.florian@gmail.com>"

ENV PACKAGES="\
    gcc \
    make \
    bash \
    shadow \
    libffi-dev \
    musl-dev \
    openssl-dev \
    py-pip \
    python \
    python-dev \
    linux-headers \
    sudo \
"

ENV PIP_PACKAGES="\
    virtualenv \
    molecule \
    ansible \
    docker-py \
"

RUN \
    apk update \
    && apk add --update --no-cache ${PACKAGES} \
    && rm -rf /var/cache/apk/* \
    && pip install --no-cache-dir ${PIP_PACKAGES} \
    && rm -rf /root/.cache

ENV SHELL /bin/bash


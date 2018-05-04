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
    git \
    openssh-client \
"

ENV PIP_PACKAGES="\
    virtualenv \
    credstash==1.14.0 \
    molecule==2.13.1 \
    ansible==2.5.2 \
    docker-py \
"

RUN \
    apk update \
    && apk add --update --no-cache ${PACKAGES} \
    && rm -rf /var/cache/apk/* \
    && pip install --no-cache-dir ${PIP_PACKAGES} \
    && rm -rf /root/.cache

ENV ANSIBLE_FORCE_COLOR=1
ENV SHELL /bin/bash

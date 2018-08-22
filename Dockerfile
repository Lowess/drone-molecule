FROM docker:dind
LABEL maintainer "Florian Dambrine <android.florian@gmail.com>"

ARG ANSIBLE_PIP_VERSION
ARG MOLECULE_PIP_VERSION

ENV ANSIBLE_PIP_VERSION=${ANSIBLE_PIP_VERSION:-2.6.3}
ENV MOLECULE_PIP_VERSION=${MOLECULE_PIP_VERSION:-2.17}

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
    molecule==${MOLECULE_PIP_VERSION} \
    ansible==${ANSIBLE_PIP_VERSION} \
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

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD []

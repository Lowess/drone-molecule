FROM docker:dind
LABEL maintainer "Florian Dambrine <android.florian@gmail.com>"

ARG ANSIBLE_PIP_VERSION
ARG MOLECULE_PIP_VERSION
ARG MITOGEN_VERSION

ENV ANSIBLE_PIP_VERSION=${ANSIBLE_PIP_VERSION:-2.6.3}
ENV MOLECULE_PIP_VERSION=${MOLECULE_PIP_VERSION:-2.17}
ENV MITOGEN_VERSION=${MITOGEN_VERSION:-0.2.3}

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
    boto \
    credstash==1.14.0 \
    molecule==${MOLECULE_PIP_VERSION} \
    ansible==${ANSIBLE_PIP_VERSION} \
    docker-py \
    pytest==3.7.2 \
"

RUN \
    apk update \
    && apk add --update --no-cache ${PACKAGES} \
    && rm -rf /var/cache/apk/* \
    && pip install -U pip --no-cache-dir \
    && pip install --no-cache-dir ${PIP_PACKAGES} \
    && rm -rf /root/.cache

ENV ANSIBLE_FORCE_COLOR=1
ENV SHELL /bin/bash

COPY entrypoint.sh /entrypoint.sh

# Add any custom modules if any
COPY library /etc/ansible/library

# Copy Extra ansible-lint rules
RUN mkdir -p /opt \
    && git clone https://github.com/Lowess/ansible-lint-rules.git /opt/gumgum-lint-rules

# Install Mitogen
RUN wget -qO- https://github.com/dw/mitogen/archive/v${MITOGEN_VERSION}.tar.gz | tar xvz -C /opt \
    && ln -s /opt/mitogen-${MITOGEN_VERSION} /opt/mitogen

ENTRYPOINT ["/entrypoint.sh"]
CMD []

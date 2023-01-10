FROM docker:dind
LABEL maintainer "Florian Dambrine <android.florian@gmail.com>"

ARG ANSIBLE_PIP_VERSION
ARG MOLECULE_PIP_VERSION
ARG MITOGEN_VERSION

ENV ANSIBLE_PIP_VERSION=${ANSIBLE_CORE_PIP_VERSION:-7.1.0}
ENV MOLECULE_PIP_VERSION=${MOLECULE_PIP_VERSION:-4.0.3}
ENV MITOGEN_VERSION=${MITOGEN_VERSION:-0.3.3}

ENV PACKAGES="\
    gcc \
    make \
    bash \
    shadow \
    libffi-dev \
    musl-dev \
    openssl-dev \
    py3-pip \
    python3 \
    python3-dev \
    linux-headers \
    sudo \
    git \
    openssh-client \
    yq \
"

ENV PIP_PACKAGES="\
    virtualenv \
    boto \
    molecule==${MOLECULE_PIP_VERSION} \
    molecule[docker]==${MOLECULE_PIP_VERSION} \
    molecule[lint]==${MOLECULE_PIP_VERSION} \
    ansible==${ANSIBLE_PIP_VERSION} \
    ansible-lint==6.8.6 \
    pytest==7.2.0 \
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
# COPY library /etc/ansible/library

# Copy Extra ansible-lint rules
RUN mkdir -p /opt \
    && git clone https://github.com/Lowess/ansible-lint-rules.git /opt/gumgum-lint-rules


# Install Mitogen
RUN wget -qO- https://github.com/mitogen-hq/mitogen/archive/refs/tags/v${MITOGEN_VERSION}.tar.gz | tar xvz -C /opt \
    && ln -s /opt/mitogen-${MITOGEN_VERSION} /opt/mitogen

ENTRYPOINT ["/entrypoint.sh"]
CMD []

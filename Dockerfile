FROM onaio/dind:19.03
LABEL maintainer "Florian Dambrine <android.florian@gmail.com>"

ARG ANSIBLE_PIP_VERSION
ARG MOLECULE_PIP_VERSION
ARG MITOGEN_VERSION

ENV ANSIBLE_PIP_VERSION=${ANSIBLE_PIP_VERSION:-2.9.2}
ENV MOLECULE_PIP_VERSION=${MOLECULE_PIP_VERSION:-2.22}
ENV MITOGEN_VERSION=${MITOGEN_VERSION:-0.2.9}

ENV PACKAGES="\
    gcc \
    make \
    bash \
    # shadow \
    libffi-dev \
    musl-dev \
    libssl1.0-dev \
    python3-pip \
    python3 \
    python3-dev \
    sudo \
    git \
    openssh-client \
    openjdk-8-jdk-headless \
    gnupg \
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
    apt-get update \
    && apt-get install -y ${PACKAGES} \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install -U pip --no-cache-dir \
    && /usr/local/bin/pip install --no-cache-dir ${PIP_PACKAGES} \
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
ENV LEIN_VERSION=2.9.1
ENV LEIN_INSTALL=/usr/local/bin/

WORKDIR /tmp

RUN mkdir ~/.gnupg || echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

# Download the whole repo as an archive
RUN \
mkdir -p $LEIN_INSTALL && \
wget -q https://raw.githubusercontent.com/technomancy/leiningen/$LEIN_VERSION/bin/lein-pkg && \
echo "Comparing lein-pkg checksum ..." && \
sha1sum lein-pkg && \
echo "93be2c23ab4ff2fc4fcf531d7510ca4069b8d24a *lein-pkg" | sha1sum -c - && \
mv lein-pkg $LEIN_INSTALL/lein && \
chmod 0755 $LEIN_INSTALL/lein && \
wget -q https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip && \
wget -q https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip.asc && \
gpg --batch --keyserver pool.sks-keyservers.net --recv-key 2B72BF956E23DE5E830D50F6002AF007D1A7CC18 && \
echo "Verifying Jar file signature ..." && \
gpg --verify leiningen-$LEIN_VERSION-standalone.zip.asc && \
rm leiningen-$LEIN_VERSION-standalone.zip.asc && \
mkdir -p /usr/share/java && \
mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar

ENV PATH=$PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1

# Install clojure 1.10.1 so users don't have to download it every time
RUN echo '(defproject dummy "" :dependencies [[org.clojure/clojure "1.10.1"]])' > project.clj \
  && lein deps && rm project.clj

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8


ENTRYPOINT ["/entrypoint.sh"]
CMD []

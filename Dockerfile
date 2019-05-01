FROM alpine:3.3

RUN apk update
RUN apk add --no-cache jq \
                       coreutils \
                       linux-headers \
                       build-base \
                       python \
                       python-dev \
                       py-pip \
                       bash \
                       less \
                       mailcap \
                       groff \
                       sudo \
                       git \
                       openssh-client \
                       ca-certificates \
    && rm -rf /var/cache/apk/* \
    && pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic \
    && pip install pyyaml

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-2.27-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-bin-2.27-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-i18n-2.27-r0.apk

RUN apk add glibc-2.27-r0.apk glibc-bin-2.27-r0.apk glibc-i18n-2.27-r0.apk
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

RUN if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python2.7 /usr/bin/python; fi
RUN if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python2.7-config /usr/bin/python-config; fi
RUN if [[ ! -e /usr/bin/easy_install ]];  then ln -sf /usr/bin/easy_install-2.7 /usr/bin/easy_install; fi

RUN easy_install pip
RUN pip install --upgrade pip
RUN if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip2.7 /usr/bin/pip; fi

RUN eval `ssh-agent -s`

COPY ./start /bin/jyparser

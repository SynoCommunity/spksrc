FROM 32bit/debian:jessie
MAINTAINER SynoCommunity <https://synocommunity.com>

# Install required packages
RUN apt-get update && \
    apt-get install -y automake \
        bison \
        build-essential \
        check \
        curl \
        cython \
        debootstrap \
        expect \
        flex \
        gettext \
        git \
        gperf \
        imagemagick \
        intltool \
        libffi-dev \
        libgc-dev \
        libltdl-dev \
        libssl-dev \
        libunistring-dev \
        mercurial \
        ncurses-dev \
        pkg-config \
        subversion \
        swig \
        xmlto \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install setuptools, pip, virtualenv, wheel and httpie
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | python
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python
RUN pip install virtualenv wheel httpie

# Volume pointing to spksrc sources
VOLUME /spksrc

WORKDIR /spksrc

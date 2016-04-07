FROM debian:jessie
MAINTAINER SynoCommunity <https://synocommunity.com>

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages
RUN apt-get update && \
    apt-get install -y automake \
        bison \
        build-essential \
        check \
        cmake \
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
        libc6-i386 \
        libcppunit-dev \
        libffi-dev \
        libgc-dev \
        libltdl-dev \
        libssl-dev \
        libunistring-dev \
        lzip \
        mercurial \
        ncurses-dev \
        pkg-config \
        python3 \
        subversion \
        swig \
        xmlto \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install setuptools, wheel and pip for Python3
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python3

# Install setuptools, pip, virtualenv, wheel and httpie for Python2
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python
RUN pip install virtualenv httpie

# Volume pointing to spksrc sources
VOLUME /spksrc

WORKDIR /spksrc

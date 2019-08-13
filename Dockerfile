FROM debian:stretch
MAINTAINER SynoCommunity <https://synocommunity.com>

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Include backports for recent Meson build tool
RUN echo "deb http://deb.debian.org/debian stretch-backports main contrib non-free" > /etc/apt/sources.list.d/stretch-backports.list

# Install required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y automake \
        libtool \
        bc \
        bison \
        build-essential \
        check \
        cmake \
        curl \
        cython \
        debootstrap \
        expect \
        flex \
        g++-multilib \
        gettext \
        git \
        gperf \
        imagemagick \
        intltool \
        libbz2-dev \
        libc6-i386 \
        libcppunit-dev \
        libffi-dev \
        libgc-dev \
        libltdl-dev \
        libmount-dev \
        libpcre3-dev \
        libssl-dev \
        libunistring-dev \
        unzip \
        lzip \
        mercurial \
        ncurses-dev \
        php \
        pkg-config \
        python3 \
        subversion \
        swig \
        xmlto \
        zlib1g-dev && \
    apt-get -t stretch-backports -y install meson && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# recent meson for fuse and sshfs

# Install setuptools, wheel and pip for Python3
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python3

# Install setuptools, pip, virtualenv, wheel and httpie for Python2
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python
RUN pip install virtualenv httpie

# Volume pointing to spksrc sources
VOLUME /spksrc

WORKDIR /spksrc

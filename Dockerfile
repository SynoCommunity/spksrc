FROM debian:buster
MAINTAINER SynoCommunity <https://synocommunity.com>

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages (in sync with README.rst instructions)
RUN apt-get update && apt-get install --no-install-recommends -y \
		autoconf-archive \
		autogen \
		automake \
		bc \
		bison \
		build-essential \
		check \
		cmake \
		curl \
		cython \
		debootstrap \
		ed \
		expect \
		fakeroot \
		flex \
		g++-multilib \
		gawk \
		gettext \
		git \
		gperf \
		imagemagick \
		intltool \
		jq \
		libbz2-dev \
		libc6-i386 \
		libcppunit-dev \
		libffi-dev \
		libgc-dev \
		libgmp3-dev \
		libltdl-dev \
		libmount-dev \
		libncurses-dev \
		libpcre3-dev \
		libssl-dev \
		libtool \
		libunistring-dev \
		lzip \
		mercurial \
		ncurses-dev \
		ninja-build \
		php \
		pkg-config \
		python3 \
		python3-distutils \
		rename \
		scons \
		subversion \
		swig \
		texinfo \
		unzip \
		xmlto \
		zlib1g-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install setuptools, wheel and pip for Python3
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python3
RUN pip3 install meson==0.56.0

# Install setuptools, pip, virtualenv, wheel and httpie for Python2
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | python
RUN pip install virtualenv httpie

# Volume pointing to spksrc sources
VOLUME /spksrc

WORKDIR /spksrc

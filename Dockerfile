FROM debian:bullseye
LABEL description="Framework for maintaining and compiling native community packages for Synology devices"
LABEL maintainer="SynoCommunity <https://github.com/SynoCommunity/spksrc/graphs/contributors>"
LABEL url="https://synocommunity.com"
LABEL vcs-url="https://github.com/SynoCommunity/spksrc"

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages (in sync with README.rst instructions)
# ATTENTION: the total length of the following RUN command must not exceed 1024 characters
RUN apt-get update && apt-get install --no-install-recommends -y \
	autoconf-archive \
	autogen \
	automake \
	autopoint \
	bash \
	bc \
	bison \
	build-essential \
	check \
	cmake \
	curl \
	cython3 \
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
	moreutils \
	ninja-build \
	patchelf \
	php \
	pkg-config \
	python2 \
	python3 \
	python3-distutils \
	rename \
	rsync \
	ruby-mustache \
	scons \
	subversion \
	sudo \
	swig \
	texinfo \
	unzip \
	xmlto \
	zip \
	zlib1g-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	adduser --disabled-password --gecos '' user && \
	adduser user sudo && \
	echo "%user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/users

# Install setuptools, wheel and pip for Python2
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | python2
# Install virtualenv and httpie for Python2
# Use pip2 as default pip -> python3
RUN pip2 install virtualenv httpie

# Install setuptools, wheel and pip for Python3
# Default pip -> python3 aware for native python wheels builds
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python3
# Install meson cross-platform build system
RUN pip3 install meson==1.0.0

# Volume pointing to spksrc sources
VOLUME /spksrc
WORKDIR /spksrc

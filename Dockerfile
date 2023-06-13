FROM debian:bookworm
LABEL description="Framework for maintaining and compiling native community packages for Synology devices"
LABEL maintainer="SynoCommunity <https://github.com/SynoCommunity/spksrc/graphs/contributors>"
LABEL url="https://synocommunity.com"
LABEL vcs-url="https://github.com/SynoCommunity/spksrc"

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages (in sync with README.rst instructions)
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
		httpie \
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
		meson \
		moreutils \
		ninja-build \
		patchelf \
		php \
		pkg-config \
		python3 \
		python3-distutils \
		python3-pip \
		python3-virtualenv \
		rename \
		rsync \
		scons \
		subversion \
		sudo \
		swig \
		texinfo \
		unzip \
		xmlto \
		zlib1g-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	adduser --disabled-password --gecos '' user && \
	adduser user sudo && \
	echo "%users ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/users

# Volume pointing to spksrc sources
VOLUME /spksrc
WORKDIR /spksrc

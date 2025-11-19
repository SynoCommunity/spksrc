FROM debian:trixie
LABEL description="Framework for maintaining and compiling native community packages for Synology devices"
LABEL maintainer="SynoCommunity <https://github.com/SynoCommunity/spksrc/graphs/contributors>"
LABEL url="https://synocommunity.com"
LABEL vcs-url="https://github.com/SynoCommunity/spksrc"

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages (in sync with README.rst instructions)
# ATTENTION: the total length of the following RUN command must not exceed 1024 characters
RUN apt update && apt install --no-install-recommends -y \
	autoconf-archive \
	autogen \
	automake \
	autopoint \
	bash \
	bash-completion \
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
	gh \
	g++-multilib \
	gawk \
	gettext \
	gfortran \
	git \
	gobject-introspection \
	gperf \
	imagemagick \
	intltool \
	jq \
	libbz2-dev \
	libc6-i386 \
	libcppunit-dev \
	libelf-dev \
	libffi-dev \
	libgc-dev \
	libgmp3-dev \
	libicu76 \
	libltdl-dev \
	libmount-dev \
	libncurses-dev \
	libpcre2-dev \
	libssl-dev \
	libtool \
	libtool-bin \
	libunistring-dev \
	lzip \
	man-db \
	manpages-dev \
	plocate \
	moreutils \
	nasm \
	p7zip \
	patchelf \
	php \
	pkg-config \
	rename \
	ripgrep \
	rsync \
	ruby-mustache \
	scons \
	subversion \
	sudo \
	swig \
	texinfo \
	time \
	tree \
	unzip \
	xmlto \
	yasm \
	zip \
	zlib1g-dev

# Python based apps
RUN apt install --no-install-recommends -y \
	httpie \
	mercurial \
	meson \
	ninja-build \
	python3 \
	python3-mako \
	python3-pip \
	python3-setuptools \
	python3-virtualenv \
	python3-yaml

###
### Keeping backport channel management for later use
###

# Add backport channel
RUN echo "deb http://deb.debian.org/debian trixie-backports main" > /etc/apt/sources.list.d/backports.list && \
    echo "Package: *\nPin: release a=trixie-backports\nPin-Priority: 100" > /etc/apt/preferences.d/99-backports

# Update package list & install needed package from backport
RUN apt-get update
###RUN apt-get install -y -t trixie-backports meson

# Clean-up apt db
RUN apt clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update locate db
RUN updatedb

# Add user
RUN adduser --disabled-password --gecos '' user && \
	adduser user sudo && \
	echo "%user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/users

# Volume pointing to spksrc sources
VOLUME /spksrc
WORKDIR /spksrc

PKG_NAME = node
PKG_VERS = 22.14.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://nodejs.org/dist/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

# C++ compiler (CXX=/spksrc/toolchain/syno-x64-7.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-g++, 8.5.0) too old, need g++ 10.1.0 or clang++ 8.0.0
# newest DSM 7.1 toolchains have g++ <= 8.5.0.
# DSM 7.2 toolchains have g++ 12.2.0 and successfuly compile nodejs v22.
REQUIRED_MIN_DSM = 7.2

HOMEPAGE = https://www.nodejs.org
COMMENT  = Node.js is an open-source, cross-platform JavaScript runtime environment.
LICENSE  = https://raw.githubusercontent.com/nodejs/node/refs/heads/main/LICENSE

CONFIGURE_ARGS = --cross-compiling --dest-os=linux --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
ENV += CC_host="gcc -m64"
ENV += CXX_host="g++ -m64"
else
ENV += CC_host="gcc -m32"
ENV += CXX_host="g++ -m32"
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --dest-cpu=arm
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --dest-cpu=arm64
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --dest-cpu=x86_64
endif

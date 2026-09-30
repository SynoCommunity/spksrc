PKG_NAME = libvpx
PKG_VERS = 1.16.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libvpx/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =
OPTIONAL_DEPENDS = native/nasm

# Needs gcc >= 7.5: needs C++17 (-std=gnu++17), i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5
# 1.16 wants more than a modern compiler: its configure refuses the 5.2 and 6.2.4
# toolchains outright. The gcc floor above said so only while those archs had an old
# gcc -- with the overlay reporting 8.5 it no longer does, so state the DSM as well.
REQUIRED_MIN_DSM = 7.0

HOMEPAGE = https://www.webmproject.org/code/
COMMENT  = WebM VP8/VP9 Codec
LICENSE = https://raw.githubusercontent.com/webmproject/libvpx/master/LICENSE

INSTALL_ARGS = install DESTDIR=$(INSTALL_DIR)

CONFIGURE_ARGS += --disable-static --enable-shared --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-vp8 --enable-vp9 --disable-examples --disable-docs --disable-unit_tests
CONFIGURE_ARGS += --enable-postproc --enable-vp9-postproc --enable-pic
CONFIGURE_ARGS += --enable-vp9-highbitdepth --enable-better-hw-compatibility
CONFIGURE_ARGS += --enable-webm-io
CONFIGURE_ARGS += --disable-multithread

include ../../mk/spksrc.common.mk

# No arm/ppc SIMD target fits ARMv5 or the e500 PowerPC: without an explicit target,
# configure falls back to the build host's (x86_64) and hands its flags to the cross gcc.
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=armv7-linux-gcc
CONFIGURE_ARGS += --disable-neon
endif

# neon_asm does not work under armv8/arm64
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=armv8-linux-gcc
endif

# Define x86asm
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
BUILD_DEPENDS = native/nasm
NASM_PATH = $(abspath $(PWD)/../../native/nasm/work-native/install/usr/local/bin)
ENV += AS=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --as=nasm
CONFIGURE_ARGS += --disable-sse4_1
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=x86-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=x86_64-linux-gcc
endif

include ../../mk/spksrc.cross-cc.mk

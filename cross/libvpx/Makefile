PKG_NAME = libvpx
PKG_VERS = 1.14.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libvpx/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =
OPTIONAL_DEPENDS = native/nasm

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.webmproject.org/code/
COMMENT  = WebM VP8/VP9 Codec
LICENSE = https://raw.githubusercontent.com/webmproject/libvpx/master/LICENSE

INSTALL_TARGET = libvpx_install

CONFIGURE_ARGS += --disable-static --enable-shared --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-vp8 --enable-vp9 --disable-examples --disable-docs --disable-unit_tests
CONFIGURE_ARGS += --enable-postproc --enable-vp9-postproc --enable-pic
CONFIGURE_ARGS += --enable-vp9-highbitdepth --enable-better-hw-compatibility
CONFIGURE_ARGS += --enable-webm-io
CONFIGURE_ARGS += --disable-multithread

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
ADDITIONAL_CPPFLAGS = -std=c++0x
ADDITIONAL_CXXFLAGS = -std=c++0x
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=armv7-linux-gcc
CONFIGURE_ARGS += --disable-neon
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
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

# Disable NEON on armv7/armv7l/armv8 when using gcc-4.9 or lower
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS)),$(ARCH))
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
CONFIGURE_ARGS += --disable-neon
endif
endif

.PHONY: libvpx_install
libvpx_install:
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

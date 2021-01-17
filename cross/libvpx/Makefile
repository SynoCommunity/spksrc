PKG_NAME = libvpx
PKG_VERS = 1.9.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libvpx/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =
OPTIONAL_DEPENDS = native/yasm

HOMEPAGE = https://www.webmproject.org/code/
COMMENT  = WebM VP8/VP9 Codec
LICENSE = https://raw.githubusercontent.com/webmproject/libvpx/master/LICENSE

INSTALL_TARGET = libvpx_install

YASM_PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin

CONFIGURE_ARGS += --disable-static --enable-shared --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-vp8 --enable-vp9 --disable-examples --disable-docs --disable-unit_tests
CONFIGURE_ARGS += --enable-postproc --enable-vp9-postproc --enable-pic
CONFIGURE_ARGS += --enable-vp9-highbitdepth --enable-better-hw-compatibility
CONFIGURE_ARGS += --disable-multithread

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
ADDITIONAL_CPPFLAGS = -std=c++0x
ADDITIONAL_CXXFLAGS = -std=c++0x
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=armv7-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=armv8-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
CONFIGURE_ARGS += --target=x86-linux-gcc --as=yasm
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
CONFIGURE_ARGS += --target=x86_64-linux-gcc --as=yasm
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: libvpx_install
libvpx_install:
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

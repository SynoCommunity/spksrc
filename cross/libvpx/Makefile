PKG_NAME = libvpx
PKG_VERS = 1.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libvpx/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.webmproject.org/code/
COMMENT  = WebM VP8/VP9 Codec
LICENSE = https://raw.githubusercontent.com/webmproject/libvpx/master/LICENSE

INSTALL_TARGET = myInstall

YASM_PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin

CONFIGURE_ARGS += --disable-static --enable-shared --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-vp8 --enable-vp9 --disable-examples --disable-docs --disable-unit_tests
CONFIGURE_ARGS += --enable-postproc --enable-vp9-postproc --enable-pic

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --target=armv7-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
CONFIGURE_ARGS += --target=x86-linux-gcc --as=yasm
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
CONFIGURE_ARGS += --target=x86_64-linux-gcc --as=yasm
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
endif


.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)


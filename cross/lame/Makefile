PKG_NAME = lame
PKG_VERS_MAJOR = 3.100
PKG_VERS = $(PKG_VERS_MAJOR)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/lame/$(PKG_NAME)/$(PKG_VERS_MAJOR)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://lame.sourceforge.net/
COMMENT  = High quality MPEG Audio Layer III encoder
LICENSE  = LGPL

GNU_CONFIGURE = 1

NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += AS=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --enable-nasm
endif


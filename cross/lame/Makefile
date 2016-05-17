PKG_NAME = lame
PKG_VERS_MAJOR = 3.99
PKG_VERS = $(PKG_VERS_MAJOR).5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/lame/$(PKG_NAME)/$(PKG_VERS_MAJOR)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://lame.sourceforge.net/
COMMENT  = High quality MPEG Audio Layer III encoder
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --with-Dll=no --with-debian=no


PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk


ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm
CONFIGURE_ARGS += --enable-nasm
ENV += AS=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin/:$$PATH
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm
CONFIGURE_ARGS += --enable-nasm
ENV += AS=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin/:$$PATH
endif


.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf -i -f -I ./m4

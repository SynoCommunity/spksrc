PKG_NAME = openal
PKG_VERS = 1.17.1
PKG_EXT = tar.bz2
PKG_DIR_SHORT = $(PKG_NAME)-soft-$(PKG_VERS)
PKG_DIR = $(PKG_DIR_SHORT)/build
PKG_DIST_NAME = $(PKG_DIR_SHORT).$(PKG_EXT)
PKG_DIST_SITE = http://kcat.strangesoft.net/openal-releases

DEPENDS = cross/alsa-lib

HOMEPAGE = http://kcat.strangesoft.net/openal.html
COMMENT  = Cross-platform, software implementation of the OpenAL 3D audio API
LICENSE  = LGPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = 
ifneq ($(findstring $(ARCH), ppc853x qoriq),)
ADDITIONAL_CFLAGS += -D_GNU_SOURCE
endif

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) cmake -DCMAKE_INSTALL_PREFIX= ..

.PHONY: myInstall
myInstall:
	$(RUN) make DESTDIR=$(STAGING_INSTALL_PREFIX) install


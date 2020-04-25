PKG_NAME = libva
PKG_VERS = 2.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libdrm

HOMEPAGE = https://01.org/vaapi
COMMENT  = Libva is an implementation for VA-API (Video Acceleration API).
LICENSE = MIT

POST_EXTRACT_TARGET = libva_custom_postextract
PRE_CONFIGURE_TARGET = libva_custom_preconfigure
POST_INSTALL_TARGET = libva_custom_postinstall

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-drivers-path=$(INSTALL_PREFIX)/lib/dri LIBS="-ldrm" --with-pic

include ../../mk/spksrc.cross-cc.mk

.PHONY: libva_custom_postextract
libva_custom_postextract:
	cp -rf /usr/include/X11 $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/

.PHONY: libva_custom_preconfigure
libva_custom_preconfigure:
	$(RUN) ./autogen.sh

.PHONY: libva_customa_postinstall
libva_custom_postinstall:
	$(RUN) install -m 665 va/x11/*.h $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/va
	$(RUN) install -m 665 va/*.h $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/va

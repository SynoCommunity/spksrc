PKG_NAME = busybox
PKG_VERS = 1.35.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://busybox.net/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://busybox.net
COMMENT  = Fairly comprehensive set of programs needed to run a Linux system
LICENSE  = GPL

CONFIGURE_TARGET = busybox_configure
INSTALL_TARGET = busybox_install

ENV += CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: busybox_configure
busybox_configure:
	cp spksrc_defconfig $(WORK_DIR)/$(PKG_DIR)/configs/spksrc_defconfig
	cat $(addprefix configs/, $(BUSYBOX_CONFIG)) | while IFS== read option value; do \
	  sed -i -r -e "s/^(# )?$$option\s.*$$/$$option=$$value/" $(WORK_DIR)/$(PKG_DIR)/configs/spksrc_defconfig ; \
	done
	$(RUN) $(MAKE) spksrc_defconfig

.PHONY: busybox_install
busybox_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/busybox $(STAGING_INSTALL_PREFIX)/bin

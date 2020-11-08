PKG_NAME = busybox
PKG_VERS = 1.26.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://busybox.net/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://busybox.net
COMMENT  = Fairly comprehensive set of programs needed to run a Linux system
LICENSE  = GPL

CONFIGURE_TARGET = busybox_configure
COMPILE_TARGET = busybox_compile
INSTALL_TARGET = busybox_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: busybox_configure
busybox_configure:
	cp spksrc_defconfig $(WORK_DIR)/$(PKG_DIR)/configs/spksrc_defconfig
	cat $(addprefix configs/, $(BUSYBOX_CONFIG)) | while IFS== read option value; do \
	  sed -i -r -e "s/^(# )?$$option.*$$/$$option=$$value/" $(WORK_DIR)/$(PKG_DIR)/configs/spksrc_defconfig ; \
	done
	$(RUN) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) $(MAKE) spksrc_defconfig

.PHONY: busybox_compile
busybox_compile:
	$(RUN) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) $(MAKE) busybox

.PHONY: busybox_install
busybox_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/busybox $(STAGING_INSTALL_PREFIX)/bin

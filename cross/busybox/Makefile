PKG_NAME = busybox
PKG_VERS = 1.25.1
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://busybox.net/downloads

DEPENDS =

HOMEPAGE = http://busybox.net
COMMENT  = Fairly comprehensive set of programs needed to run a Linux system
LICENSE  = GPL

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	cp spksrc_defconfig $(WORK_DIR)/$(PKG_DIR)/configs/spksrc_defconfig
	cat $(addprefix configs/, $(BUSYBOX_CONFIG)) | while IFS== read option value; do \
	  sed -i -r -e "s/^(# )?$$option.*$$/$$option=$$value/" $(WORK_DIR)/$(PKG_DIR)/configs/spksrc_defconfig ; \
	done
	$(RUN) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) $(MAKE) spksrc_defconfig

.PHONY: myCompile
myCompile:
	$(RUN) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) $(MAKE) busybox

.PHONY: myInstall
myInstall:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/busybox $(STAGING_INSTALL_PREFIX)/bin

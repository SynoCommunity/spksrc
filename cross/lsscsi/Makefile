PKG_NAME = lsscsi
PKG_VERS = 0.30
SVN_REV = r154
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sg.danny.cz/scsi
PKG_DIR = $(PKG_NAME)-$(subst .,,$(PKG_VERS))$(SVN_REV)

HOMEPAGE = http://sg.danny.cz/scsi/lsscsi.html
COMMENT  = The lsscsi command lists information about SCSI devices in Linux. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix="$(STAGING_INSTALL_PREFIX)"

INSTALL_TARGET = lsscsi_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: lsscsi_custom_install
lsscsi_custom_install:
	$(RUN) $(MAKE) install

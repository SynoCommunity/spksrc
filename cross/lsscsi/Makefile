PKG_NAME = lsscsi
PKG_VERS = 0.32
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sg.danny.cz/scsi
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://sg.danny.cz/scsi/lsscsi.html
COMMENT  = The lsscsi command lists information about SCSI devices in Linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix="$(STAGING_INSTALL_PREFIX)"

include ../../mk/spksrc.cross-cc.mk

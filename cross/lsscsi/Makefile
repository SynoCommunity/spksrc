PKG_NAME = lsscsi
PKG_VERS = 0.32
PKG_EXT = tar.gz
PKG_DIST_NAME = r$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/doug-gilbert/lsscsi/archive/refs/tags
PKG_DIR = $(PKG_NAME)-r$(PKG_VERS)

HOMEPAGE = http://sg.danny.cz/scsi/lsscsi.html
COMMENT  = The lsscsi command lists information about SCSI devices in Linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix="$(STAGING_INSTALL_PREFIX)"
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

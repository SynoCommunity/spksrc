PKG_NAME = unrar
PKG_VERS = 7.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.rarlab.com/rar
PKG_DIR = $(PKG_NAME)

DEPENDS =

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://rarlab.com
COMMENT  = Extract files from rar archives.
LICENSE  = freeware

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

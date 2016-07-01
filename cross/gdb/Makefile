PKG_NAME = gdb
PKG_VERS = 7.11
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)

DEPENDS = cross/termcap

HOMEPAGE = http://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger
LICENSE  =

ENV += PATH=$$PATH:$(STAGING_INSTALL_PREFIX)/bin
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk

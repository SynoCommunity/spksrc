PKG_NAME = wget
PKG_VERS = 1.14
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)

DEPENDS = 

HOMEPAGE = http://www.gnu.org/software/wget/
COMMENT  = GNU Wget is a free software package for retrieving files using HTTP, HTTPS and FTP, the most widely-used Internet protocols.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --without-ssl

include ../../mk/spksrc.cross-cc.mk

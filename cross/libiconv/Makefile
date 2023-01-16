PKG_NAME = libiconv
PKG_VERS = 1.17
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/pub/gnu/libiconv
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/libiconv
COMMENT  = GNU libiconv provides an implementation of the iconv() function and the iconv program for character set conversion. For use on systems which don't have one, or whose implementation cannot convert from/to Unicode. 
LICENSE  = GNU GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

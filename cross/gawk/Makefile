PKG_NAME = gawk
PKG_VERS = 4.1.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/gawk/
COMMENT  = The awk utility interprets a special-purpose programming language that makes it possible to handle simple data-reformatting jobs with just a few lines of code.

LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk

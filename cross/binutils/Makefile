PKG_NAME = binutils
PKG_VERS = 2.26
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS	= 

HOMEPAGE = https://sourceware.org/binutils/
COMMENT  = The GNU Binutils are a collection of binary tools
LICENSE  = GNU

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls

TC_TARGET = x86_64-unknown-linux-gnu
export TC_TARGET

include ../../mk/spksrc.cross-cc.mk


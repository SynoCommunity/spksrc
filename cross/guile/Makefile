PKG_NAME = guile
PKG_VERS = 2.0.5
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/pub/gnu/$(PKG_NAME)

DEPENDS  = cross/libtool cross/gmp cross/libunistring cross/libffi cross/gc
DEPENDS += native/$(PKG_NAME)

HOMEPAGE = http://www.gnu.org/software/guile/
COMMENT  = Guile is the GNU Ubiquitous Intelligent Language for Extensions, the official extension language for the GNU operating system
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = GUILE_FOR_BUILD=$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/libguile/guile
ENV += GUILE_LOAD_PATH=$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/module GUILE_AUTO_COMPILE=0


include ../../mk/spksrc.cross-cc.mk

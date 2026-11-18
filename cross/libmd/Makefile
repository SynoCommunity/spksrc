PKG_NAME = libmd
PKG_VERS = 1.2.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://libbsd.freedesktop.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.hadrons.org/software/libmd/
COMMENT = Message Digest functions from BSD systems
LICENSE = 3-Clause BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

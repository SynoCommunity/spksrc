PKG_NAME = libevent
PKG_VERS_MAJOR = 2.0
PKG_VERS_MINOR = 22-stable
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/levent/files/release-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)

DEPENDS = cross/openssl

HOMEPAGE = http://libevent.org
COMMENT  = An event notification library
LICENSE  = http://libevent.org/LICENSE.txt

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

PKG_NAME = userspace-rcu
PKG_VERS = 0.14.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://lttng.org/files/urcu/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://liburcu.org/
COMMENT  = liburcu is a userspace RCU (read-copy-update) library. This data synchronization library provides read-side access which scales linearly with the number of cores.
LICENSE  = LGPL v2.1

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

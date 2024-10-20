PKG_NAME = lm-sensors
PKG_VERS = 3.6.0
PKG_DIST_VERS = $(subst .,-,$(PKG_VERS))
PKG_EXT = tar.gz
PKG_DIST_NAME = V$(PKG_DIST_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lm-sensors/lm-sensors/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_DIST_VERS)

DEPENDS =

HOMEPAGE = https://hwmon.wiki.kernel.org/
COMMENT  = lm-sensors provides user-space support for the hardware monitoring drivers in Linux 2.6.5 and later.
LICENSE  = GPLv2

# run make install only
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) ETCDIR=$(INSTALL_PREFIX_VAR) BUILD_STATIC_LIB=0

include ../../mk/spksrc.cross-cc.mk

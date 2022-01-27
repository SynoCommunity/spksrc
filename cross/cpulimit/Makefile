PKG_NAME = cpulimit
PKG_VERS = 0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/opsengine/cpulimit/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/src

DEPENDS =

CONFIGURE_TARGET = nop
INSTALL_TARGET = cpulimit_install

HOMEPAGE = https://github.com/opsengine/cpulimit
COMMENT  = CPU usage limiter for Linux.
LICENSE  = GPLv2+

include ../../mk/spksrc.cross-cc.mk

.PHONY: cpulimit_install
cpulimit_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) ; install -m 755 cpulimit $(STAGING_INSTALL_PREFIX)/bin/

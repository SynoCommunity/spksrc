PKG_NAME = autoconf
PKG_VERS = 2.72
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/autoconf/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/m4

HOMEPAGE = https://www.gnu.org/software/autoconf/
COMMENT  = Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
POST_INSTALL_TARGET = autoconf_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: autoconf_post_install
autoconf_post_install:
	@$(MSG) Patch scripts to use installed m4 as default
	@sed -i.bak -e 's|/usr/bin/m4|$(INSTALL_PREFIX)/bin/m4|g' $(STAGING_INSTALL_PREFIX)/bin/autom4te
	@sed -i.bak -e 's|/usr/bin/m4|$(INSTALL_PREFIX)/bin/m4|g' $(STAGING_INSTALL_PREFIX)/bin/autoupdate

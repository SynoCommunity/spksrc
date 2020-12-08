PKG_NAME = acl
PKG_VERS = 2.2.52
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/acl
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/attr

HOMEPAGE = https://savannah.nongnu.org/projects/acl/
COMMENT  = Commands for Manipulating POSIX Access Control Lists.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1
INSTALL_TARGET = acl_install
CONFIGURE_ARGS = --enable-static=no


include ../../mk/spksrc.cross-cc.mk

.PHONY: acl_install
acl_install:
	$(RUN) $(MAKE) DIST_ROOT=$(INSTALL_DIR) install install-lib install-dev

# httpdocs/dist is a git submodule. GitHub tag archives leave it empty.
# Pin the exact submodule commit referenced by the ntopng 7.0 tag.
PKG_NAME = ntopng-dist
PKG_VERS = 73db7d7e43e2f0b624d1666f52dcdbbe1db0c189
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ntop/ntopng-dist/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/ntop/ntopng-dist
COMMENT  = Prebuilt ntopng frontend files (httpdocs/dist submodule).
LICENSE  = GPLv3

INSTALL_TARGET = ntopng_dist_install

include ../../mk/spksrc.cross-install.mk

.PHONY: ntopng_dist_install
ntopng_dist_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/ntopng/httpdocs/dist
	@cp -R $(WORK_DIR)/$(PKG_DIR)/. $(STAGING_INSTALL_PREFIX)/share/ntopng/httpdocs/dist/

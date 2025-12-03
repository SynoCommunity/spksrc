PKG_NAME = pigz
PKG_VERS = 2.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/madler/pigz/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://zlib.net/pigz/
COMMENT  = A parallel implementation of gzip for modern multi-processor, multi-core machines.
LICENSE  = zlib

# pigz uses simple Makefile, no configure available
CONFIGURE_TARGET = nop

# CFLAGS as in original Makefile:
ADDITONAL_CFLAGS = -O3 -Wall -Wextra -Wno-unknown-pragmas -Wcast-qual

INSTALL_TARGET = pigz_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: pigz_install
pigz_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/pigz $(STAGING_INSTALL_PREFIX)/bin/
	@ln -sf pigz $(STAGING_INSTALL_PREFIX)/bin/unpigz

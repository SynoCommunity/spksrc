PKG_NAME = mtproxy
PKG_VERS = 1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/TelegramMessenger/MTProxy/archive
PKG_DIST_FILE = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = MTProxy-$(PKG_VERS)
PKG_GIT_HASH = f9158e3129efd4ccdc291aefb840209791226a77

DEPENDS = cross/openssl

HOMEPAGE = https://github.com/TelegramMessenger/MTProxy
COMMENT = Simple MT-Proto proxy server
LICENSE = GPL

# Only Intel supported https://github.com/TelegramMessenger/MTProxy/issues/18
COMPILE_MAKE_OPTIONS += SPKSRC_CFLAGS="$(CFLAGS)"
COMPILE_MAKE_OPTIONS += SPKSRC_LDFLAGS="$(LDFLAGS)"
COMPILE_MAKE_OPTIONS += COMMIT="$(PKG_GIT_HASH)"
COMPILE_MAKE_OPTIONS += ARCH=

CONFIGURE_TARGET = nop
INSTALL_TARGET = mtproxy_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: mtproxy_install
mtproxy_install:
		@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
		@install -m 755 $(WORK_DIR)/$(PKG_DIR)/objs/bin/mtproto-proxy $(STAGING_INSTALL_PREFIX)/bin/

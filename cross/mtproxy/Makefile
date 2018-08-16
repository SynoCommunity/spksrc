PKG_NAME = mtproxy
PKG_VERS = 0.01
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = f9158e3
PKG_DIST_SITE = https://github.com/TelegramMessenger/MTProxy.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/openssl

HOMEPAGE = https://github.com/TelegramMessenger/MTProxy
COMMENT = Simple MT-Proto proxy server
LICENSE = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS =

CONFIGURE_TARGET = nop
COMPILE_TARGET = mtproxy_compile
INSTALL_TARGET = mtproxy_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: mtproxy_compile
mtproxy_compile:
		$(RUN) $(MAKE) SPKSRC_CFLAGS="$(CFLAGS)" SPKSRC_LDFLAGS="$(LDFLAGS)" COMMIT="$(PKG_GIT_HASH)" ARCH=

.PHONY: mtproxy_install
mtproxy_install:
		@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
		@install -m 755 $(WORK_DIR)/$(PKG_DIR)/objs/bin/mtproto-proxy $(STAGING_INSTALL_PREFIX)/bin/

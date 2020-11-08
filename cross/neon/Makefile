PKG_NAME = neon
PKG_VERS = 0.31.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/notroj/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/zlib cross/openssl

HOMEPAGE = https://notroj.github.io/neon/
COMMENT  = Neon is an HTTP and WebDAV client library, with a C interface.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --disable-static
CONFIGURE_ARGS += --with-libxml2 --with-ssl=openssl --with-zlib XML2_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/xml2-config
PRE_CONFIGURE_TARGET = neon_pre_configure
INSTALL_TARGET = neon_install
POST_INSTALL_TARGET = neon_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: neon_pre_configure
neon_pre_configure:
	@$(RUN) ; ./autogen.sh

.PHONY: neon_install
neon_install:
	@$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install-lib install-headers install-config prefix=$(INSTALL_PREFIX)

# davfs2 configure needs neon-config (with corrected prefix) to evaluate neon capabilities.
.PHONY: neon_post_install
neon_post_install:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/neon-config

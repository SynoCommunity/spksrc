PKG_NAME = neon
PKG_VERS = 0.31.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/notroj/neon/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/zlib cross/openssl

HOMEPAGE = https://notroj.github.io/neon/
COMMENT  = Neon is an HTTP and WebDAV client library, with a C interface.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --disable-static
CONFIGURE_ARGS += --with-libxml2 XML2_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/xml2-config
CONFIGURE_ARGS += --with-zlib --with-ssl=openssl

PRE_CONFIGURE_TARGET = neon_pre_configure
POST_INSTALL_TARGET = neon_post_install

INSTALL_MAKE_OPTIONS = install-lib install-headers install-config DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: neon_pre_configure
neon_pre_configure:
	@$(RUN) ; ./autogen.sh

# davfs2 configure needs neon-config (with corrected prefix) to evaluate neon capabilities.
.PHONY: neon_post_install
neon_post_install:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/neon-config

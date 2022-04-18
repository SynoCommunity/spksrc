PKG_NAME = cryptopp
PKG_VERS = 8.6.0
PKG_EXT = tar.gz
DIST_BASE_NAME = CRYPTOPP_$(subst .,_,$(PKG_VERS))
PKG_DIST_NAME = $(DIST_BASE_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/weidai11/cryptopp/archive
PKG_DIR = $(PKG_NAME)-$(DIST_BASE_NAME)

DEPENDS =

HOMEPAGE = https://cryptopp.com/
COMMENT  = Crypto++ Library is a free C++ class library of cryptographic schemes.
LICENSE  = Boost Software License 1.0

CONFIGURE_TARGET = nop
INSTALL_TARGET = cryptopp_install

ADDITIONAL_CXXFLAGS = -DNDEBUG -g2 -O -fPIC -pipe

MAKE_OPTIONS = -f GNUmakefile HAS_SOLIB_VERSION=1
COMPILE_MAKE_OPTIONS = $(MAKE_OPTIONS) shared

include ../../mk/spksrc.cross-cc.mk

.PHONY: cryptopp_install
cryptopp_install:
	@$(RUN) $(MAKE) $(MAKE_OPTIONS) install-lib DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
	@cd $(STAGING_INSTALL_PREFIX)/lib && ln -sf libcryptopp.so.$(PKG_VERS) libcryptopp.so.$(firstword $(subst ., ,$(PKG_VERS)))

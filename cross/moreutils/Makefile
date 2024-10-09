PKG_NAME = moreutils
PKG_VERS = 0.69
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = https://deb.debian.org/debian/pool/main/m/moreutils/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://joeyh.name/code/moreutils/
COMMENT  = moreutils is a collection of the unix tools that nobody thought to write long ago when unix was young.
LICENSE  = GPLv2

CONFIGURE_TARGET = moreutils_configure
INSTALL_TARGET = moreutils_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: moreutils_configure
# remove the x64 binaries in the package (and ignore configure)
moreutils_configure:
	@$(RUN) $(MAKE) clean

.PHONY: moreutils_install
moreutils_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) install -t $(STAGING_INSTALL_PREFIX)/bin/ isutf8 ifdata ifne pee sponge mispipe lckdo parallel errno ts

PKG_NAME = node
PKG_VERS = 0.12.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://nodejs.org/dist/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(ARMv5_ARCHES) $(PPC_ARCHES)

HOMEPAGE = http://nodejs.org/
COMMENT  = Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications.
LICENSE  = MIT

CONFIGURE_ARGS = --without-snapshot --dest-os=linux --prefix=$(STAGING_INSTALL_PREFIX)
ENV += LINK.target=$(TC_PATH)$(TC_PREFIX)g++

POST_INSTALL_TARGET = myPostInstall

# Limit to supported archs
ifneq ($(findstring $(ARCH),bromolow cedarview x86 armadaxp armada370 armada375 avoton alpine x64),$(ARCH))
$(error $(ARCH) is not a supported architecture)
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^#\!$(STAGING_INSTALL_PREFIX)|#\!$(INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/lib/node_modules/npm/bin/npm-cli.js

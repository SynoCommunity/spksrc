PKG_NAME = zerotier
PKG_VERS = 1.16.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zerotier/ZeroTierOne/archive/refs/tags
PKG_DIST_FILE = ZeroTierOne-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = ZeroTierOne-$(PKG_VERS)

DEPENDS =

# C++17
REQUIRED_MIN_DSM = 7.0

HOMEPAGE = https://www.zerotier.com
COMMENT  = ZeroTier One, the client of the ZeroTier network virtualization platform.
# Client only: the MPL-2.0 code. The controller (nonfree/) is not built.
LICENSE  = MPL-2.0

include ../../mk/spksrc.common.mk

CONFIGURE_TARGET = nop
COMPILE_TARGET = zerotier_compile
INSTALL_TARGET = zerotier_install

include ../../mk/spksrc.cross-cc.mk

# ZT_SSO_SUPPORTED=0: no Rust/OIDC component (given on the command line, it
# overrides the per-architecture defaults in make-linux.mk).
.PHONY: zerotier_compile
zerotier_compile:
	$(RUN) $(MAKE) one ZT_SSO_SUPPORTED=0

.PHONY: zerotier_install
zerotier_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/zerotier-one $(STAGING_INSTALL_PREFIX)/bin/zerotier-one

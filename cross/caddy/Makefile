PKG_NAME = caddy
PKG_VERS = 2.11.4
PKG_EXT = tar.gz
PKG_DIST_NAME = caddy_$(PKG_VERS)_linux_$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/caddyserver/caddy/releases/download/v$(PKG_VERS)

REQUIRED_MIN_DSM = 7.0

HOMEPAGE = https://caddyserver.com/
COMMENT  = Fast, multi-platform web server with automatic HTTPS
LICENSE  = Apache-2.0

INSTALL_TARGET = caddy_install

# No 32-bit x86 ("386") or classic PowerPC/ppc64le build is published upstream,
# so those Synology families can't run this package regardless of packaging.
UNSUPPORTED_ARCHS = $(i686_ARCHS) $(PPC_ARCHS)
# hi3535 (ARMv7L) isn't covered by the generic armv7 mapping below and its ABI
# match with upstream's armv7 (hardfloat) build hasn't been verified.
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

# Upstream ships prebuilt Linux binaries for all of these.
PKG_DIST_ARCH_LIST = amd64 arm64 armv7 armv5

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = amd64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = armv7
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
else ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
PKG_DIST_ARCH = armv5
endif

include ../../mk/spksrc.cross-install.mk

.PHONY: caddy_install
caddy_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/caddy $(STAGING_INSTALL_PREFIX)/bin/caddy

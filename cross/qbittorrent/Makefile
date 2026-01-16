PKG_NAME = qbittorrent
PKG_VERS = 5.1.4
PKG_EXT =
PKG_DIST_NAME = $(PKG_DIST_ARCH)-qbittorrent-nox
PKG_DIST_SITE = https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-$(PKG_VERS)_v2.0.11
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.qbittorrent.org/
COMMENT  = qBittorrent BitTorrent client with web interface
LICENSE  = GPLv2

INSTALL_TARGET = qbittorrent_install

# Static binaries from userdocs/qbittorrent-nox-static
# Available: x86_64, aarch64, armv7, x86
PKG_DIST_ARCH_LIST = x86_64 aarch64 armv7 x86

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x86_64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = aarch64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = armv7
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x86
endif

# Unsupported architectures (no static binary available)
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS)

include ../../mk/spksrc.install-resources.mk

.PHONY: qbittorrent_install
qbittorrent_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(DISTRIB_DIR)/$(PKG_DIST_NAME) $(STAGING_INSTALL_PREFIX)/bin/qbittorrent-nox

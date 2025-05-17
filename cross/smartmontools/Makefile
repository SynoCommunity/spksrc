PKG_NAME = smartmontools
PKG_VERS = 7.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/smartmontools/smartmontools/releases/download/RELEASE_$(subst .,_,$(PKG_VERS))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libcap-ng

# archs lacking std=c++11
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.smartmontools.org/
COMMENT = smartmontools contains two utility programs (smartctl and smartd) to control and monitor storage systems using the Self-Monitoring, Analysis and Reporting Technology System (SMART).
LICENSE = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-libcap-ng
CONFIGURE_ARGS += --sysconfdir=$(INSTALL_PREFIX_VAR)

ADDITIONAL_CPPFLAGS = -O

POST_INSTALL_TARGET = smartmontools_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: smartmontools_post_install
smartmontools_post_install:
	@$(MSG) Create link smartctl7
	@cd $(STAGING_INSTALL_PREFIX)/sbin && ln -sf smartctl smartctl7

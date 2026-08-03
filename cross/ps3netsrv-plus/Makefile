PKG_NAME = ps3netsrv-plus
PKG_VERS = 2.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-x64.$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.com/api/v4/projects/85053958/packages/generic/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-linux-x64

REQUIRED_MIN_DSM = 7.3
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://gitlab.com/nathanchere/ps3netsrv-plus
COMMENT = Read-only NETISO server and DSM management interface for PlayStation 3 media.
LICENSE = Apache-2.0

INSTALL_TARGET = ps3netsrv_plus_install

include ../../mk/spksrc.cross-install.mk

.PHONY: ps3netsrv_plus_install
ps3netsrv_plus_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/bin/ps3netsrv-plus $(STAGING_INSTALL_PREFIX)/bin/
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/bin/ps3netsrv-go $(STAGING_INSTALL_PREFIX)/bin/
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/bin/libchdr.so $(STAGING_INSTALL_PREFIX)/bin/
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/app
	cp -R $(WORK_DIR)/$(PKG_DIR)/webui/. $(STAGING_INSTALL_PREFIX)/app/
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/licenses
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/licenses/*.txt $(STAGING_INSTALL_PREFIX)/share/licenses/
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/doc/ps3netsrv-plus
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/VERSION $(STAGING_INSTALL_PREFIX)/share/doc/ps3netsrv-plus/

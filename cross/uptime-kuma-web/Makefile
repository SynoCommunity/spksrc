PKG_NAME = uptime-kuma-web
PKG_VERS = 2.5.5
PKG_EXT = tar.gz
PKG_DIST_NAME = dist.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/louislam/uptime-kuma/releases/download/$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = dist

HOMEPAGE = https://uptime.kuma.pet
COMMENT  = Pre-built web frontend for Uptime Kuma
LICENSE  = MIT

INSTALL_TARGET = uptime_kuma_web_install

include ../../mk/spksrc.cross-install.mk

.PHONY: uptime_kuma_web_install
uptime_kuma_web_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/uptime-kuma
	cp -a $(WORK_DIR)/$(PKG_DIR) $(STAGING_INSTALL_PREFIX)/share/uptime-kuma/dist
	( cd $(STAGING_INSTALL_PREFIX) && \
		find share/uptime-kuma -type f -o -type l | sort ) \
		> $(WORK_DIR)/$(PKG_NAME).plist
	printf 'rsc:share/uptime-kuma\n' > $(WORK_DIR)/PLIST

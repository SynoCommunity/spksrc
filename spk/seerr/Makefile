SPK_NAME = seerr
SPK_VERS = 3.0.1
SPK_REV = 2
SPK_ICON = src/seerr.png

DEPENDS = cross/seerr
BUILD_DEPENDS = native/nodejs_22

REQUIRED_MIN_DSM = 7.2
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = "Media request management for Jellyfin, Plex, and Emby with automation integrations."
DISPLAY_NAME = Seerr
CHANGELOG = "Update to v3.0.1"
HOMEPAGE = https://github.com/seerr-team/seerr
LICENSE = MIT

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

SERVICE_PORT = 5055
SERVICE_PORT_TITLE = Seerr (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

SPK_DEPENDS = "Node.js_v22"

POST_STRIP_TARGET += seerr_install

include ../../mk/spksrc.spk.mk

.PHONY: seerr_install
seerr_install:
	install -m 755 -d $(STAGING_DIR)/share
	cp -a $(STAGING_INSTALL_PREFIX)/share/seerr $(STAGING_DIR)/share/
	install -m 755 -d $(STAGING_DIR)/var/config
	cp -a $(STAGING_DIR)/share/seerr/config/. $(STAGING_DIR)/var/config/ || true
	rm -rf $(STAGING_DIR)/share/seerr/config
	ln -sf /var/packages/$(SPK_NAME)/var/config $(STAGING_DIR)/share/seerr/config

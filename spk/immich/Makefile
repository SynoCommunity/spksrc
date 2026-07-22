SPK_NAME = immich
SPK_VERS = 3.0.3
SPK_REV = 4
SPK_ICON = src/immich.png

DEPENDS = cross/immich cross/immich-geodata
SPK_DEPENDS = "Node.js_v22:postgresql>=17.10-4:redis:Perl:python314:ffmpeg8"

REQUIRED_MIN_DSM = 7.2
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = SynoCommunity
DISPLAY_NAME = Immich
DESCRIPTION = Self-hosted photo and video backup solution.
CHANGELOG = "1. Update Immich to v3.0.3. <br/>2. Preserve ML virtualenv across upgrades. <br/>3. Add HEIC thumbnail support."
HOMEPAGE = https://immich.app
LICENSE = GPLv3

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 2283
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard
SERVICE_WIZARD_SHARENAME = wizard_media_share

POST_STRIP_TARGET = immich_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: immich_extra_install
immich_extra_install:
	@$(MSG) Install service launchers
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/server-launcher.js $(STAGING_DIR)/bin/
	install -m 755 src/bin/immich-ml-launcher.sh $(STAGING_DIR)/bin/
	@$(MSG) Install runtime config template
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/etc/immich.conf $(STAGING_DIR)/etc/immich.conf

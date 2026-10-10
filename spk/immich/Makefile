SPK_NAME = immich
SPK_VERS = 3.3.1
SPK_REV = 8
SPK_ICON = src/immich.png

DEPENDS = cross/immich cross/immich-geodata
SPK_DEPENDS = "Node.js_v22:postgresql>=17.10-4:redis:Perl:python314:ffmpeg8"

REQUIRED_MIN_DSM = 7.2
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = SynoCommunity
DISPLAY_NAME = Immich
DESCRIPTION = Self-hosted photo and video backup solution.
CHANGELOG = "Update Immich to v3.3.1."
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

SPK_COMMANDS = bin/immich-admin

# immich-model is a git-only dependency (see machine-learning/uv.lock);
# the wheel is prebuilt here (pinned rev) so no git binary is needed on DSM.
IMMICH_MODEL_REV = 8bf3fd1b44b0c8608f52fb6e50ddff52826576d8

include ../../mk/spksrc.spk.mk

.PHONY: immich_extra_install
immich_extra_install:
	@$(MSG) Install service launchers
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/server-launcher.js $(STAGING_DIR)/bin/
	install -m 755 src/bin/immich-ml-launcher.sh $(STAGING_DIR)/bin/
	install -m 755 src/bin/immich-admin $(STAGING_DIR)/bin/
	@$(MSG) Install runtime config template
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/etc/immich.conf $(STAGING_DIR)/etc/immich.conf
	@$(MSG) Prebuild immich-model wheel
	install -m 755 -d $(STAGING_DIR)/share/immich/wheelhouse
	pip3 wheel --no-deps --no-cache-dir -w $(STAGING_DIR)/share/immich/wheelhouse \
		"immich-model @ git+https://github.com/immich-app/ml-models.git@$(IMMICH_MODEL_REV)"

SPK_NAME = qui
SPK_VERS = 1.31.1
SPK_REV = 1
SPK_ICON = src/qui.png

DEPENDS = cross/qui

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = hgy59
HOMEPAGE = https://getqui.com/
DESCRIPTION = A fast, single-binary qBittorrent web UI: manage multiple instances, automate torrent workflows, and cross-seed across trackers.
LICENSE = GPLv2+
DISPLAY_NAME = qui
CHANGELOG = "Initial package release."

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

SERVICE_USER = auto
SERVICE_PORT = 7476
SERVICE_PORT_TITLE = qui (HTTP)

POST_STRIP_TARGET = qui_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: qui_extra_install
qui_extra_install:
	@$(MSG) Install config.toml
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 600 src/config.toml $(STAGING_DIR)/var/

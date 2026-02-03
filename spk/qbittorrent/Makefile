SPK_NAME = qbittorrent
SPK_VERS = 5.1.4
SPK_REV = 2
SPK_ICON = src/qbittorrent.png

DEPENDS = cross/qbittorrent cross/qbittorrent-pwhash
SPK_DEPENDS = python312

REQUIRED_MIN_DSM = 6.0
REQUIRED_MIN_SRM = 1.3

MAINTAINER = SynoCommunity
DESCRIPTION = qBittorrent is a cross-platform free and open-source BitTorrent client with a feature-rich web interface for remote access.
STARTABLE = yes
DISPLAY_NAME = qBittorrent
CHANGELOG = "Fix search functionality by adding Python 3.12 dependency."

HOMEPAGE = https://www.qbittorrent.org
LICENSE  = GPLv2

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8095
SERVICE_PORT_TITLE = qBittorrent Web UI

ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = qbittorrent_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: qbittorrent_extra_install
qbittorrent_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/qBittorrent/config
	install -m 644 src/qBittorrent.conf $(STAGING_DIR)/var/qBittorrent/config/qBittorrent.conf

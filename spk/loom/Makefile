SPK_NAME = loom
SPK_VERS = 0.4.5
SPK_REV = 3
SPK_ICON = src/loom.png

DEPENDS = cross/loom

MAINTAINER = Ebenderooock
HOMEPAGE = https://loom.deroock.co.za
LICENSE = AGPL-3.0
DISPLAY_NAME = Loom

DESCRIPTION = Loom is a unified, self-hosted media automation server. It searches indexers, drives your download clients, imports and organizes movies and TV, and ships a built-in web UI and request portal — a single-binary replacement for the Radarr/Sonarr/Prowlarr/Overseerr stack.

CHANGELOG = "Update Loom to v0.4.5."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Loom serves its web UI and API over plain HTTP on this port; put it behind the
# DSM reverse proxy for TLS. Default upstream listen port is 1925.
SERVICE_PORT = 1925
SERVICE_PORT_TITLE = Loom Web UI
ADMIN_PORT = $(SERVICE_PORT)

FWPORTS = src/loom.sc

include ../../mk/spksrc.spk.mk

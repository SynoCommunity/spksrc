SPK_NAME = Komga
SPK_VERS = 1.24.4
SPK_REV  = 1
SPK_ICON = src/komga.png

DEPENDS     = cross/komga
SPK_DEPENDS = java-21-openjdk

REQUIRED_MIN_DSM = 7.0
REQUIRED_MIN_SRM = 1.3

MAINTAINER   = SynoCommunity
DESCRIPTION  = Komga is a media server for your comics, mangas, BDs, magazines and eBooks.
STARTABLE    = yes
DISPLAY_NAME = Komga
CHANGELOG    = "init package"

HOMEPAGE = https://komga.org/
LICENSE  = MIT

WIZARDS_DIR =

SERVICE_USER       = auto
SERVICE_SETUP      = src/service-setup.sh
SERVICE_PORT       = 25600
SERVICE_PORT_TITLE = Komga web UI

ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
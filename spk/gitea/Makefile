SPK_NAME = gitea
SPK_VERS = 1.17.2
SPK_REV = 9
SPK_ICON = src/$(SPK_NAME).png

MAINTAINER = wkobiela
DESCRIPTION  = Gitea is a community managed lightweight code hosting solution written in Go.
DISPLAY_NAME = Gitea
CHANGELOG = "1. Update to v1.17.2."

LICENSE = MIT

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "git>=2"

SERVICE_USER         = auto
SERVICE_SETUP        = src/service-setup.sh
STARTABLE            = yes
WIZARDS_DIR          = src/wizard
SERVICE_WIZARD_SHARE = wizard_gitea_dir

# Use shared folder provided by DSM for DSM 6 too (not only for DSM 7).
USE_DATA_SHARE_WORKER = yes

SERVICE_PORT = 8418
SERVICE_PORT_TITLE = Gitea (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk

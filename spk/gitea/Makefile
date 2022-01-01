SPK_NAME = gitea
SPK_VERS = 1.15.9
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

MAINTAINER = publicarray
DESCRIPTION  = Gitea is a community managed lightweight code hosting solution written in Go.
DISPLAY_NAME = Gitea
CHANGELOG = "First release"

LICENSE = MIT

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "git>=2"

SERVICE_USER         = auto
SERVICE_SETUP        = src/service-setup.sh
STARTABLE            = yes
WIZARDS_DIR          = src/wizard
SERVICE_WIZARD_SHARE = wizard_gitea_dir

SERVICE_PORT = 8418
SERVICE_PORT_TITLE = Gitea (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk

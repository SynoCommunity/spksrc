SPK_NAME = filebrowser
SPK_VERS =  2.22.4
SPK_REV = 2
SPK_ICON = src/filebrowser.png

DEPENDS = cross/$(SPK_NAME)
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = publicarray
DISPLAY_NAME = File Browser
DESCRIPTION = filebrowser provides a file managing interface within a specified directory and it can be used to upload, delete, preview, rename and edit your files. It allows the creation of multiple users and each user can have its own directory.
HOMEPAGE = https://filebrowser.org/
HELPURL = https://github.com/filebrowser/filebrowser/issues
LICENSE = Apache 2.0
CHANGELOG = "1. Update filebrowser to v2.22.4.<br/>2. Built with go v1.18.6 and node v16.15.1."

GROUP = synocommunity

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8091
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = File Browser (HTTP)

include ../../mk/spksrc.spk.mk

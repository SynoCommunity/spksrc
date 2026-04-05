SPK_NAME = filebrowser
SPK_VERS = 2.59.0
SPK_REV = 9
SPK_ICON = src/filebrowser.png

DEPENDS = cross/filebrowser

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = publicarray
DISPLAY_NAME = File Browser
DESCRIPTION = File Browser provides a file managing interface within a specified directory and it can be used to upload, delete, preview and edit your files.
HOMEPAGE = https://filebrowser.org/
HELPURL = https://github.com/filebrowser/filebrowser/issues
LICENSE = Apache 2.0
CHANGELOG = "1. Update File Browser to v2.59.0 <br/>2. Built with go v1.25.4 and node v24.11.1."

GROUP = synocommunity

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8091
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = File Browser (HTTP)

include ../../mk/spksrc.spk.mk

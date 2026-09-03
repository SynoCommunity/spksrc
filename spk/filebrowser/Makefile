SPK_NAME = filebrowser
SPK_VERS = 2.63.23
SPK_REV = 11
SPK_ICON = src/filebrowser.png

DEPENDS = cross/filebrowser

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = publicarray
DISPLAY_NAME = File Browser
DESCRIPTION = File Browser provides a file managing interface within a specified directory and it can be used to upload, delete, preview and edit your files.
HOMEPAGE = https://filebrowser.org/
HELPURL = https://github.com/filebrowser/filebrowser/issues
LICENSE = Apache 2.0
CHANGELOG = "Update File Browser to v2.63.23 <br/>This is the very last version that was released. Further development of filebrowser has been discontinued and the GitHub repository has been archived."

GROUP = synocommunity

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8091
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = File Browser (HTTP)

include ../../mk/spksrc.spk.mk

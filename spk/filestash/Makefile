SPK_NAME = filestash
SPK_VERS = 20260910
SPK_REV = 1
SPK_ICON = src/filestash.png

DEPENDS = cross/filestash
SPK_DEPENDS = "ffmpeg8"

MAINTAINER = SynoCommunity
DESCRIPTION = Filestash is a web file manager that connects to SFTP, S3, WebDAV, local disk and cloud storage through a single interface.
DISPLAY_NAME = Filestash
CHANGELOG = "Initial package. Filestash snapshot 20260910."

HOMEPAGE = https://filestash.app
LICENSE = AGPL-3.0

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8334
SERVICE_PORT_TITLE = Filestash (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

include ../../mk/spksrc.spk.mk

SPK_NAME = rest-server
SPK_VERS = 0.11.0
SPK_REV = 1
SPK_ICON = src/logo.png
DSM_UI_DIR = app

DEPENDS = cross/rest-server

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = fgma
DESCRIPTION = Rest Server is a high performance HTTP server that implements restic's REST backend API.
DISPLAY_NAME = Restic rest-server
CHANGELOG = "Initial release."
LICENSE_FILE = $(WORK_DIR)/rest-server/LICENSE
HOMEPAGE = https://restic.net/
LICENSE = BSD 2-Clause License

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_WIZARD_SHARE = wizard_data_directory
USE_DATA_SHARE_WORKER = yes
FWPORTS = src/rest-server.sc
ADMIN_PORT = 8500

include ../../mk/spksrc.spk.mk

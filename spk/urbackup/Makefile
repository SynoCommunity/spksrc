SPK_NAME = urbackup
SPK_VERS = 2.5.25
SPK_REV = 1
SPK_ICON = src/urbackup.png
DSM_UI_DIR = app

DEPENDS = cross/urbackup-server cross/urbackup-client

# see cross/cryptopp
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

MAINTAINER = josef109
DESCRIPTION = UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
DISPLAY_NAME = UrBackup
CHANGELOG = "Initial package release v2.5 (server v2.5.25, client v2.5.19)."

HOMEPAGE = https://www.urbackup.org/
LICENSE  = AGPL-3.0

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_backup_dir
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 55414
SERVICE_PORT_TITLE = UrBackup Web UI

SPK_COMMANDS = bin/blockalign bin/urbackupclientctl bin/urbackupclientbackend

include ../../mk/spksrc.spk.mk

SPK_NAME = urbackup-server
SPK_VERS = 2.5.33
SPK_REV = 1
SPK_ICON = src/urbackup.png
DSM_UI_DIR = app

DEPENDS = cross/urbackup-server

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
DISPLAY_NAME = UrBackup Server
CHANGELOG = "Initial package release v2.5.33."

HOMEPAGE = https://www.urbackup.org/
LICENSE  = AGPL 3+

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARENAME = wizard_backup_dir
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 55414
SERVICE_PORT_TITLE = UrBackup Web UI

SPK_COMMANDS = bin/urbackupsrv

include ../../mk/spksrc.spk.mk

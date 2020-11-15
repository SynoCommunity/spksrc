SPK_NAME = urbackup
SPK_VERS = 2.4.13
SPK_REV = 1
SPK_ICON = src/urbackup.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

# see cross/cryptopp
UNSUPPORTED_ARCHS = powerpc ppc824x ppc853x ppc854

MAINTAINER = josef109
DESCRIPTION = UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
ADMIN_URL = /urbackup/
RELOAD_UI = yes
DISPLAY_NAME = UrBackup
CHANGELOG = "Initial package release"

HOMEPAGE = https://www.urbackup.org/
LICENSE  = AGPL-3.0

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER         = auto
SERVICE_WIZARD_SHARE = wizard_backup_dir
SERVICE_SETUP        = src/service-setup.sh
STARTABLE            = yes

SERVICE_PORT = 55414
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/bin/urbackupsrv run -d -v error -u sc-urbackup --pidfile $${PID_FILE} --logfile $${LOG_FILE}

DEFAULT_BACKUP_FOLDER = $(STAGING_DIR)/var/backup

include ../../mk/spksrc.spk.mk

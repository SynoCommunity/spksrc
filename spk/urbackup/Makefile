SPK_NAME = urbackup
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/urbackup.png
DSM_UI_DIR = app
REQUIRED_DSM = 6.0

DEPENDS = cross/$(SPK_NAME) 

MAINTAINER = Josef
DESCRIPTION = UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.

DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com
RELOAD_UI = yes
DISPLAY_NAME = Urbackup

HOMEPAGE   = http://www.urbackup.org/
LICENSE    = GPLv3

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

POST_STRIP_TARGET = urbackup_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: urbackup_extra_install
urbackup_extra_install:
	install -m 755 -d $(STAGING_DIR)/var

        


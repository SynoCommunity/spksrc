SPK_NAME = urbackup
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/urbackup.png
DSM_UI_DIR = app
<<<<<<< HEAD
REQUIRED_DSM = 6.0

DEPENDS = cross/$(SPK_NAME) 

MAINTAINER = Josef
DESCRIPTION = UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.

DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com
RELOAD_UI = yes
DISPLAY_NAME = Urbackup
=======

DEPENDS  = cross/busybox cross/$(SPK_NAME) 

MAINTAINER = Josef
DESCRIPTION = UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
ADMIN_URL = /urbackup/
RELOAD_UI = yes
DISPLAY_NAME = Urbackup
CHANGELOG = " urbackup"
BETA = 1
PARALLEL_MAKE=4
>>>>>>> e697f224... add urbackup support

HOMEPAGE   = http://www.urbackup.org/
LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/
<<<<<<< HEAD

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER         = auto
SERVICE_WIZARD_SHARE = wizard_backup_dir
SERVICE_SETUP        = src/service-setup.sh
STARTABLE            = yes



SERVICE_PORT = 55414
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/bin/urbackupsrv run -d -v error -u sc-urbackup --pidfile $${PID_FILE} --logfile $${LOG_FILE}
=======
#CONF_DIR = src/conf/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER         = auto
SERVICE_SETUP        = src/service-setup.sh
STARTABLE            = yes

SERVICE_PORT = 55414
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

SERVICE_EXE = $${SYNOPKG_PKGDEST}/bin/urbackupsrv
>>>>>>> e697f224... add urbackup support


# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

<<<<<<< HEAD
=======
#FWPORTS = src/${SPK_NAME}.sc

#PRE_COPY_TARGET = urbackup_extra_install
>>>>>>> e697f224... add urbackup support

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
DEFAULT_BACKUP_FOLDER = $(STAGING_DIR)/var/backup

POST_STRIP_TARGET = urbackup_extra_install

<<<<<<< HEAD
=======
BUSYBOX_CONFIG = usrmng daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"


>>>>>>> e697f224... add urbackup support
include ../../mk/spksrc.spk.mk

.PHONY: urbackup_extra_install
urbackup_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
<<<<<<< HEAD
	@mkdir -p $(STAGING_DIR)/var/urbackup

=======
	mkdir $(STAGING_DIR)/var/urbackup
>>>>>>> e697f224... add urbackup support

        


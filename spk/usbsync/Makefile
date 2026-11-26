SPK_NAME = usbsync
SPK_VERS = 1.9.7
SPK_REV = 1
SPK_ICON = src/usbsync.png

DEPENDS = cross/usbsync

MAINTAINER = Ali Raza
MAINTAINER_URL = https://github.com/alirz1/usbsync
DESCRIPTION = Sync NAS shared folders to and from USB/eSATA drives with rsync. Two-pane picker, dry-run previews, mirroring, saved jobs with schedules, auto-eject, pause/resume and Gmail/Pushbullet notifications.
DISPLAY_NAME = USB Sync
CHANGELOG = "Settings backups are password-protected (AES-256). Import asks for the backup password, or can import without passwords."
HOMEPAGE = https://github.com/alirz1/usbsync
LICENSE = BSD-3-Clause
LICENSE_FILE = $(WORK_DIR)/src/github.com/usbsync-$(SPK_VERS)/LICENSE

# Web UI served on this port, opened from Package Center
ADMIN_PORT = 8765
ADMIN_URL = /
FWPORTS = src/usbsync.sc

SERVICE_USER = auto
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT = src/start-stop-status

include ../../mk/spksrc.spk.mk

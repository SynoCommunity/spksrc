SPK_NAME = urbackup-client
SPK_VERS = 2.5.25
SPK_REV = 1
SPK_ICON = src/urbackup.png
DSM_UI_DIR = app

DEPENDS = cross/urbackup-client

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
DISPLAY_NAME = UrBackup Client
CHANGELOG = "Initial package release v2.5.25."

HOMEPAGE = https://www.urbackup.org/
LICENSE  = AGPL-3.0

STARTABLE = no

SPK_COMMANDS = bin/blockalign bin/urbackupclientctl bin/urbackupclientbackend

include ../../mk/spksrc.spk.mk

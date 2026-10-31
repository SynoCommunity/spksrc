SPK_NAME = archivestation
SPK_VERS = 1.0.2
SPK_REV = 1
SPK_ICON = src/archivestation.png

DEPENDS = cross/archivestation
SPK_DEPENDS = python312
SPK_CONFLICT = ArchiveStation

# Both the application and Waitress are pure Python. Use the installed Python
# package rather than rebuilding or embedding an interpreter.
WHEELS = src/requirements-pure.txt
override ARCH = noarch
REQUIRED_MIN_DSM = 7.0

MAINTAINER = jbdemonte
DESCRIPTION = Download public Internet Archive items into separate folders with file selection, progress tracking, resumable transfers, integrity verification and scheduling. Opens inside the DSM desktop and uses your administrator session.
DISPLAY_NAME = Archive Station
CHANGELOG = "Initial SynoCommunity package of Archive Station 1.0.2, including automatic DSM session recovery."
HOMEPAGE = https://github.com/jbdemonte/synology-archive-downloader
LICENSE = MIT
STARTABLE = yes

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
# Retain upstream's bounded shutdown and process identity checks.
SSS_SCRIPT = src/start-stop-status
DSM_UI_DIR = ui
DSM_APP_NAME = com.archivestation.app
CONF_DIR = src/conf
WIZARDS_DIR = src/wizard

# Render distribution metadata after the standard staging/strip steps.
POST_STRIP_TARGET = archivestation_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: archivestation_extra_install
archivestation_extra_install:
	$(MAKE) --no-print-directory -C ../../cross/archivestation \
		WORK_DIR=$(WORK_DIR) $(FWRD_ARGS) \
		ARCHIVESTATION_DESTDIR=$(STAGING_DIR) \
		ARCHIVESTATION_VERSION=$(SPK_VERS)-$(SPK_REV) archivestation_stage

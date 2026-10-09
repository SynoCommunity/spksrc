SPK_NAME = archivestation
SPK_VERS = 1.0.1
SPK_REV = 2
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
CHANGELOG = "Initial SynoCommunity package of Archive Station 1.0.1."
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

include ../../mk/spksrc.spk.mk

# Cross dependencies are cached independently of SPK_REV. Render the final
# payload and regenerate INFO on every packaging run, after the staging copy.
.PHONY: archivestation_stage
archivestation_stage: copy
	python3 $(WORK_DIR)/ArchiveStation-$(SPK_VERS)-1-source/scripts/stage_synology.py \
		--destination $(STAGING_DIR) --version "$(SPK_VERS)-$(SPK_REV)" \
		--package-id archivestation --python-relative env/bin/python3

$(WORK_DIR)/package.tgz $(WORK_DIR)/INFO: archivestation_stage

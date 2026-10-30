SPK_NAME = rdiff-backup
SPK_VERS = 2.2.7
SPK_REV = 8
SPK_ICON = src/rdiff-backup.png

PYTHON_PACKAGE = python314

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/librsync cross/attr cross/acl

# [PyYAML]
DEPENDS += cross/libyaml

MAINTAINER = SynoCommunity
DESCRIPTION = Reverse differential backup tool, over a network or locally.
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "1. Update to v2.2.7. <br/>2. Migrate to Python 3.14."

HOMEPAGE = https://rdiff-backup.net/
LICENSE  = GPLv2

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
POST_SERVICE_TARGET = rdiff-backup_extra_install

# https://github.com/SynoCommunity/spksrc/issues/4427
USE_ALTERNATE_TMPDIR = 1

SPK_USR_LOCAL_LINKS = bin:env/bin/rdiff-backup bin:env/bin/rdiff-backup-delete bin:env/bin/rdiff-backup-statistics

include ../../mk/spksrc.spk-meta.mk

.PHONY: rdiff-backup_extra_install
rdiff-backup_extra_install:
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup

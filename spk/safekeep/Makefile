SPK_NAME = safekeep
SPK_VERS = 1.4.4
SPK_REV = 1
SPK_ICON = src/safekeep.png

PKG_NAME = $(SPK_NAME)
PKG_VERS = $(SPK_VERS)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/safekeep/files/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 
#WHEELS = 
SPK_DEPENDS = "python>2.7.8-10:rdiff-backup"

MAINTAINER = SynoCommunity
DESCRIPTION = SafeKeep is a centralized and easy to use backup application that combines the best features of a mirror and an incremental backup. It sets up the appropriate environment for compatible backup packages and simplifies the process of running them.
RELOAD_UI = yes
DISPLAY_NAME = SafeKeep
CHANGELOG = "First Release"

HOMEPAGE   = https://safekeep.sourceforge.com/
LICENSE    = GNU GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /
POST_STRIP_TARGET = safekeep_extra_install
PRE_COPY_TARGET = create_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: create_install
create_install:
	mkdir work/install

.PHONY: safekeep_extra_install
safekeep_extra_install: work/$(PKG_DIR)
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 -d $(STAGING_DIR)/etc/cron.d
	install -m 755 -d $(STAGING_DIR)/etc/safekeep/backup.d
	install -m 644 src/safekeep.conf $(STAGING_DIR)/etc/safekeep
	install -m 644 src/host1.backup.sample $(STAGING_DIR)/etc/safekeep/backup.d
	install -m 644 src/safekeep-backups.sh $(STAGING_DIR)/bin
	install -m 644 src/safekeep.cron $(STAGING_DIR)/etc/cron.d/safekeep
	install -m 755 work/$(PKG_DIR)/safekeep $(STAGING_DIR)/bin

#work/$(PKG_DIR): work/$(PKG_DIST_SITE)/$(PKG_DIST_NAME)
work/$(PKG_DIR):
	cd work && wget $(PKG_DIST_SITE)/$(PKG_DIST_NAME) && tar xvzf $(PKG_DIST_NAME)

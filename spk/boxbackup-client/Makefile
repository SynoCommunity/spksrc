SPK_NAME = boxbackup-client
SPK_VERS = 0.11.1
SPK_REV = 1
SPK_ICON = src/boxbackup.png

DEPENDS = cross/boxbackup
SPK_DEPENDS = "Perl"

MAINTAINER = SynoCommunity
DESCRIPTION = Box Backup is an open source, completely automatic, on-line backup system. This is the client part of Box Backup.
DISPLAY_NAME = Box Backup Client

HOMEPAGE = http://www.boxbackup.org/
LICENSE  = BSD/GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = boxbackup-client_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: boxbackup-client_extra_install
boxbackup-client_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 src/syno-bbackupd-config $(STAGING_DIR)/sbin/syno-bbackupd-config
	install -m 755 src/syno-bbackupctl $(STAGING_DIR)/sbin/syno-bbackupctl
	install -m 755 src/syno-bbackupquery $(STAGING_DIR)/sbin/syno-bbackupquery

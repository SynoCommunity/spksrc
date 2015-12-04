SPK_NAME = duply
SPK_VERS = 1.11
SPK_REV = 1

SPK_ICON = src/duply.png

DEPENDS = cross/bash cross/$(SPK_NAME)
SPK_DEPENDS = duplicity

DESCRIPTION = duply is a frontend for the mighty duplicity magic. duplicity is a python based shell application that makes encrypted incremental backups to remote storages. Different backends like ftp, sftp, imap, s3 and others are supported. See duplicity manpage for a complete list of backends and features.

STARTABLE = no
DISPLAY_NAME = duply
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE = http://duply.net/
LICENSE  = GNU General Public License

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk


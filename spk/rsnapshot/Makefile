SPK_NAME = rsnapshot
SPK_VERS = 1.4.2
SPK_REV = 1
SPK_ICON = src/rdiff-backup.png

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "Perl"

MAINTAINER = Peeter123
DESCRIPTION = Rsnapshot is a filesystem snapshot utility. It can take incremental snapshots of local and remote filesystems. 
STARTABLE = no
DISPLAY_NAME = rsnapshot
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE = http://rsnapshot.org/
LICENSE  = GNU-GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

SPK_NAME = dar
SPK_VERS = 2.5.15
SPK_REV = 1
SPK_ICON = src/dar.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = spacifici
DESCRIPTION = dar is a shell command that backs up from a single file to a whole filesystems, taking care of hard links, Extended Attributes, sparse files, MacOS's file forks, any inode type (including Solaris Door inodes), etc. 
STARTABLE = no
DISPLAY_NAME = DAR
# CHANGELOG = ""

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

HOMEPAGE = http://dar.linux.free.fr/
LICENSE  = GPLv2

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

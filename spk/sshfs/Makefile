SPK_NAME = sshfs
SPK_VERS = 2.5
SPK_REV = 1
SPK_ICON = src/sshfs.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = sshfs is a filesystem client based on the SSH File Transfer Protocol
DISPLAY_NAME = sshfs
STARTABLE = no
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE   = http://fuse.sourceforge.net/sshfs.html
LICENSE    = GNU GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk


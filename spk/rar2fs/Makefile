SPK_NAME = rar2fs
SPK_VERS = 2.10
SPK_REV = 2
SPK_ICON = src/sshfs.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = rar2fs is a filesystem client based on the SSH File Transfer Protocol
DISPLAY_NAME = rar2fs
STARTABLE = no
CHANGELOG = "Update to version 2.10"
BETA = 1

HOMEPAGE   = https://github.com/libfuse/sshfs
LICENSE    = GPLv2, LGPLv2.1 (libfuse.so, libulockmgr.so)

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk


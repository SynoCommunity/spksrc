SPK_NAME = sshfs-fuse
SPK_VERS = 2.5
SPK_REV = 1
SPK_ICON = src/sshfs-fuse.png

DEPENDS = cross/$(SPK_NAME) cross/fuse cross/glib cross/zlib cross/libffi

MAINTAINER = SynoCommunity
DESCRIPTION = This is a filesystem client based on the SSH File Transfer Protocol
DESCRIPTION_GER = 
RELOAD_UI = no
DISPLAY_NAME = sshfs
STARTABLE = no
CHANGELOG = "Initial release"

HOMEPAGE   = http://fuse.sourceforge.net/sshfs.html
LICENSE    = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

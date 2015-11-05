SPK_NAME = fuse-exfat
SPK_VERS = 1.2.1
SPK_REV = 2  
SPK_ICON = src/fuse.png

DEPENDS = cross/$(SPK_NAME) cross/exfat-utils

MAINTAINER = Roman Tymoshyk 
DESCRIPTION = Add support of exFAT filesystem
DISPLAY_NAME = exFAT
STARTABLE = no
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE = https://github.com/relan/exfat
LICENSE  = GNU GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk


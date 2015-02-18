SPK_NAME = sudo
SPK_VERS = 7.4
SPK_REV = 2
SPK_ICON = src/sudo.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = frv
DESCRIPTION = "Sudo allows a system administrator to delegate authority to give certain users (or groups of users) the ability to run some (or all) commands as root or another user while providing an audit trail of the commands and their arguments."
RELOAD_UI = no
DISPLAY_NAME = sudo
STARTABLE = no
BETA = 1

HOMEPAGE   = http://www.sudo.ws
LICENSE    = ISC-style license (TODO: check the compliance of the licence)

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = sudo_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: sudo_extra_install
sudo_extra_install:

SPK_NAME = comskip
SPK_VERS = 0.81.094
SPK_REV = 1
SPK_ICON = src/comskip.png
BETA = 1

REQUIRED_DSM = 5.2

DEPENDS = cross/$(SPK_NAME)

STARTABLE = no

MAINTAINER = schumi2004
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE = http://www.kaashoek.com/comskip/
LICENSE = GNU/LGPL
HELPURL = https://github.com/SynoCommunity/spksrc/wiki/Comskip
SUPPORTURL = http://www.kaashoek.com/comskip/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = comskip_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: comskip_extra_install
comskip_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/comskip.ini $(STAGING_DIR)/var/comskip.ini
	install -m 644 src/comskip.dictionary $(STAGING_DIR)/var/comskip.dictionary



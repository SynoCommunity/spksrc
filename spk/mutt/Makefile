SPK_NAME = mutt
SPK_VERS = 1.5.24
SPK_REV = 2
SPK_ICON = src/mutt.png

DEPENDS = cross/mutt

MAINTAINER = SynoCommunity
DESCRIPTION = Mutt is a small but very powerful text-based mail client for Unix operating systems.
RELOAD_UI = no
DISPLAY_NAME = Mutt
STARTABLE = no
BETA = 1
CHANGELOG = Update to 1.5.24

HOMEPAGE   = http://www.mutt.org
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mutt_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mutt_extra_install
mutt_extra_install:
	install -m 755 src/mutt-utf8 $(STAGING_DIR)/bin/mutt-utf8
	install -m 644 src/Muttrc.local $(STAGING_DIR)/etc/Muttrc.local
	echo "source $(INSTALL_PREFIX)/etc/Muttrc.local" >> $(STAGING_DIR)/etc/Muttrc

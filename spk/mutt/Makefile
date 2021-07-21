SPK_NAME = mutt
SPK_VERS = 2.0.6
SPK_REV = 7
SPK_ICON = src/mutt.png

DEPENDS = cross/mutt

MAINTAINER = SynoCommunity
DESCRIPTION = Mutt is a small but very powerful text-based mail client for Unix operating systems.
DISPLAY_NAME = Mutt
STARTABLE = no

CHANGELOG = "1. Update to mutt v2.0.6.<br/>2. utf-8 wrapper removed."

HOMEPAGE   = http://www.mutt.org
LICENSE    = GPLv2

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = bin/mutt

POST_STRIP_TARGET = mutt_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mutt_extra_install
mutt_extra_install:
	install -d -m 755 $(STAGING_DIR)/var
	install -m 644 src/Muttrc.local $(STAGING_DIR)/var/Muttrc.local
	echo "source $(INSTALL_PREFIX)/var/Muttrc.local" >> $(STAGING_DIR)/etc/Muttrc

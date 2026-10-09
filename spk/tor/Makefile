SPK_NAME = tor
SPK_VERS = 0.2.5.12
SPK_REV = 1
SPK_ICON = src/tor.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = Tor is free software for enabling anonymous communication. The name is an acronym derived from the original software project name The Onion Router.
DISPLAY_NAME = Tor

BETA = 1

HOMEPAGE   = https://www.torproject.org
LICENSE    = https://gitweb.torproject.org/tor.git/plain/LICENSE

RELOAD_UI = no
STARTABLE = yes
NO_SERVICE_SHORTCUT = true

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = tor_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: tor_extra_install
tor_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/torrc.bridge $(STAGING_DIR)/var/torrc.bridge
	install -m 600 src/torrc.noexit $(STAGING_DIR)/var/torrc.noexit
	install -m 600 src/torrc.exit $(STAGING_DIR)/var/torrc.exit

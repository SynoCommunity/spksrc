SPK_NAME = tor
SPK_VERS = 0.2.5.12
SPK_REV = 1
SPK_ICON = src/tor.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Tor is free software for enabling anonymous communication. The name is an acronym derived from the original software project name The Onion Router.
RELOAD_UI = no
DISPLAY_NAME = Tor

BETA = 1

HOMEPAGE   = https://www.torproject.org
LICENSE    = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = tor_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk


.PHONY: tor_extra_install
tor_extra_install: 
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/torrc $(STAGING_DIR)/var/torrc

SPK_NAME = shairport
SPK_VERS = 2.2.2
SPK_REV = 1
SPK_ICON = src/shairport.png

DEPENDS =  cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Use Synology NAS as an AirPlay receiver. Requires USB soundcard or speakers.
RELOAD_UI = no
DISPLAY_NAME = ShairPort
CHANGELOG = "Initial SynoCommunity Release"

HOMEPAGE = https://github.com/abrasive/shairport
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = shairport_extra_install

BUSYBOX_CONFIG = daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: shairport_extra_install
shairport_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/alsa.conf $(STAGING_DIR)/share/alsa/alsa.conf

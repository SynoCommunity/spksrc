SPK_NAME = oscam
SPK_VERS = 1.20~r7536
SPK_REV = 1
SPK_ICON = src/oscam.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = OSCam is a multi-protocol and cross-platform card server. A card server is a software which acts as a key host for card clients. A card server usually has one or more smartcard readers and ethernet interface. It emulates conditional access module \(CAM\) for accessing smartcard and offers virtual common interface to the clients. OSCam has a card client and a web interface
DESCRIPTION_FRE = OSCam est un card server multi-protocole et mutli-plateforme. Un card server est un logiciel qui agit comme une clé d\'hôte pour les card clients. Un card server a généralement un ou plusieurs lecteur de cartes à puce et une interface Ethernet. Il émule un Conditional Access Module \(CAM\) pour accéder à la carte à puce virtuelle et offre une interface commune pour les clients. OSCam a un card client et une interface web
ADMIN_PORT = 83
RELOAD_UI = yes
DISPLAY_NAME = OSCam

HOMEPAGE = https://www.oscam.to/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = oscam_extra_install

ENV += BUSYBOX_CONFIG=usermng_pidof_defconfig
include ../../mk/spksrc.spk.mk

.PHONY: oscam_extra_install
oscam_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/oscam.conf $(STAGING_DIR)/var/oscam.conf
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/oscam.cgi.pl $(STAGING_DIR)/app/oscam.cgi

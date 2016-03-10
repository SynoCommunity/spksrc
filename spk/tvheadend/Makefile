SPK_NAME = tvheadend
SPK_VERS = 3.4.27
SPK_REV = 6
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = ZI660
DESCRIPTION = Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV and Analog video \(V4L\) as input sources. It also comes with a powerful and easy to use web interface both used for configuration and day-to-day operations, such as searching the EPG and scheduling recordings. Even so, the most notable feature of Tvheadend is how easy it is to set up: Install it, navigate to the web user interface, drill into the TV adapters tab, select your current location and Tvheadend will start scanning channels and present them to you in just a few minutes
DESCRIPTION_FRE = Tvheadend est un serveur de streaming pour linux gérant les sources DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV et video analogique \\\(V4L\\\). Il possède aussi une interface web puissante et ergonomique pour la configuration tout comme l\\\'utilisation au quotidien : recherche EPG ou plannification d\\\'enregistrements. Le principal point fort de Tvheadend réside avant tout dans sa facilité d\\\'utilisation : installez-le, naviguez au travers de son interface web, choisissez votre adaptateur TV dans l\\\'onglet dédié ainsi que votre localisation et Tvheadend recherchera les cannaux et vous les affichera en seulement quelques minutes
ADMIN_PORT = 9981
RELOAD_UI = yes
DISPLAY_NAME = Tvheadend
CHANGELOG = "Update to version 3.4.27"

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = tvheadend_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: tvheadend_extra_install
tvheadend_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/tvheadend.cgi.pl $(STAGING_DIR)/app/tvheadend.cgi
	install -m 755 -d $(STAGING_DIR)/var/accesscontrol
	install -m 700 src/accesscontrol.json $(STAGING_DIR)/var/accesscontrol/1
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

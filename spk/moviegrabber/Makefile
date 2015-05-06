SPK_NAME = MovieGrabber
SPK_VERS = 2.2.1.0
SPK_REV = 3
SPK_ICON = src/moviegrabber.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = binhex
DISTRIBUTOR = Matr1x
DESCRIPTION = MovieGrabber is a fully automated way of downloading movies from usenet. It supports any nzb client that has a watched or monitor folder facility such as SABnzbd and NZBGet. MovieGrabber works by checking imdb for matching criteria and if a match is found the nzb will be downloaded and stored in either a specified queued folder for user review or sent to the watched folder for processing and automatic downloading via your usenet binary client.
DESCRIPTION_NLD = MovieGrabber is een programma om automatisch films te downloaden van usenet. Elk nzb programma dat een bewaakte map functie heeft wordt ondersteund, zoals bijvoorbeeld SABnzbd en NZBGet. MovieGrabber controleert bij imdb of een film aan de opgegeven zoekcriteria voldoet en zal het nzb bestand in de wachtrij zetten voor handmatige controle of direct in de bewaakte plaatsen zodat de film gedownload zal worden.
ADMIN_PORT = 9191
RELOAD_UI = yes
DISPLAY_NAME = MovieGrabber
CHANGELOG = "1. Updated the package installer"

HOMEPAGE   = https://github.com/binhex/moviegrabber/tree/development
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/moviegrabber.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = moviegrabber_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: moviegrabber_extra_install
moviegrabber_extra_install: $(STAGING_DIR)/share/moviegrabber
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/moviegrabber.cgi $(STAGING_DIR)/app/moviegrabber.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/share/moviegrabber/* $(STAGING_DIR)
	rm -R $(STAGING_DIR)/share

$(STAGING_DIR)/share/moviegrabber:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone -b development https://github.com/binhex/moviegrabber.git
	rm -fr $(STAGING_DIR)/share/moviegrabber/.git $(STAGING_DIR)/share/moviegrabber/.gitignore
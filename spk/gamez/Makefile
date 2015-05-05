SPK_NAME = gamez
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/gamez.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = avjui
DESCRIPTION = Gamez is an automated downloader for video games. The user adds the games they wish to download and Gamez will attempt to find the game and download it.
DESCRIPTION_NLD = Gamez is een geautomatiseerde downloader voor videospelletjes. De gebruiker voegt de games toe die ze willen downloaden en Gamez zal proberen om het spel te vinden en te downloaden.
ADMIN_PORT = 5290
RELOAD_UI = yes
DISPLAY_NAME = Gamez

HOMEPAGE   = https://github.com/avjui/Gamez
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = gamez_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: gamez_extra_install
gamez_extra_install: $(STAGING_DIR)/share/Gamez
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/Gamez.ini $(STAGING_DIR)/var/Gamez.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/gamez.cgi $(STAGING_DIR)/app/gamez.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/share/Gamez/* $(STAGING_DIR)
	rm -R $(STAGING_DIR)/share

$(STAGING_DIR)/share/Gamez:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/avjui/Gamez.git
	rm -fr $(STAGING_DIR)/share/Gamez/.git $(STAGING_DIR)/share/Gamez/.gitignore
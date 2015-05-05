SPK_NAME = plexconnect
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/plexconnect.png

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = iBaa
DISTRIBUTOR = Matr1x
DESCRIPTION = Plex Connect or: Plex @ aTV - think different...
RELOAD_UI = yes
DISPLAY_NAME = PlexConnect

HOMEPAGE   = https://github.com/iBaa/PlexConnect/
LICENSE    =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = plexconnect_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: gamez_extra_install
plexconnect_extra_install: $(STAGING_DIR)/share/PlexConnect
	mv $(STAGING_DIR)/share/PlexConnect/* $(STAGING_DIR)
	rm -R $(STAGING_DIR)/share

$(STAGING_DIR)/share/PlexConnect:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/iBaa/PlexConnect.git
	rm -fr $(STAGING_DIR)/share/PlexConnect/.git $(STAGING_DIR)/share/PlexConnect/.gitignore
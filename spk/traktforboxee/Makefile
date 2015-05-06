SPK_NAME = TraktForBoxee
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/traktforboxee.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = cold12
DISTRIBUTOR = Matr1x
DESCRIPTION = Trakt For Boxee is a simple python script that will scrobble whatever you re watching on your Boxee Box to Trakt.
DESCRIPTION_NLD = Trakt For Boxee is een eenvoudig python script dat alles wat je met je Boxee Box kijkt scrobbelt naar Trakt.
RELOAD_UI = yes
DISPLAY_NAME = TraktForBoxee
CHANGELOG = "1. Updated the package installer"

HOMEPAGE   = https://github.com/cold12/Trakt-for-Boxee
LICENSE    =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = traktforboxee_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: traktforboxee_extra_install
traktforboxee_extra_install: $(STAGING_DIR)/share/Trakt-for-Boxee
	install -m 600 src/config.ini $(STAGING_DIR)/share/Trakt-for-Boxee/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/share/Trakt-for-Boxee/* $(STAGING_DIR)
	rm -R $(STAGING_DIR)/share

$(STAGING_DIR)/share/Trakt-for-Boxee:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/cold12/Trakt-for-Boxee.git
	rm -fr $(STAGING_DIR)/share/Trakt-for-Boxee/.git $(STAGING_DIR)/share/Trakt-for-Boxee/.gitignore
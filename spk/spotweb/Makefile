SPK_NAME = Spotweb
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/spotweb.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS =

MAINTAINER = spotweb
DESCRIPTION = Spotweb is a webbased usenet binary resource indexer based on the protocol and development done by Spotnet.
DESCRIPTION_NLD = Spotweb is een webbased usenet binaire bron indexer op basis van het protocol en ontwikkeling gedaan door Spotnet.
ADMIN_URL = /spotweb
RELOAD_UI = yes
DISPLAY_NAME = Spotweb
CHANGELOG = "1. Updated the package installer"

HOMEPAGE   = https://github.com/spotweb/spotweb
LICENSE    =

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = spotweb_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: spotweb_extra_install
spotweb_extra_install: $(STAGING_DIR)/www
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/www/spotweb/* $(STAGING_DIR)/www

$(STAGING_DIR)/www:
	install -m 755 -d $(STAGING_DIR)/www
	cd $(STAGING_DIR)/www && git clone https://github.com/spotweb/spotweb.git
	rm -fr $(STAGING_DIR)/www/.git $(STAGING_DIR)/www/.gitignore
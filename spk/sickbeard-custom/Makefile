SPK_NAME = sickbeard-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 4
SPK_ICON = src/sickbeard-custom.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = SickBeard Custom allows you to run the fork of your choice of SickBeard. You will be asked for the fork\'s git URL during install.
DESCRIPTION_FRE = SickBeard Custom vous permet d\\\'exécuter le fork de votre choix de SickBeard. Vous aurez besoin de saisir l\\\'URL git du fork durant l\\\'installation.
ADMIN_PORT = 8083
RELOAD_UI = yes
DISPLAY_NAME = SickBeard Custom
CHANGELOG = "Maintenance release"

HOMEPAGE   = http://sickbeard.com
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = sickbeard-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickbeard-custom_extra_install
sickbeard-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

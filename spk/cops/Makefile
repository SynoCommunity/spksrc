SPK_NAME = cops
SPK_VERS = 1.5.4
SPK_REV = 9
SPK_ICON = src/cops.png

DEPENDS  = cross/cops
# Pure PHP package, make sure ARCH is not defined
override ARCH=

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS=WebStation:PHP7.4:Apache2.4

MAINTAINER = Diaoul
DESCRIPTION = Calibre OPDS and HTML PHP Server : light alternative to Calibre content server / Calibre2OPDS.
DESCRIPTION_FRE = Calibre OPDS et HTML PHP Serveur : alternative légère au serveur de contenu de Calibre et à Calibre2OPDS.
DISPLAY_NAME = COPS
CHANGELOG = "1. Update to 1.5.4"

HOMEPAGE = https://blog.slucas.fr/en/oss/calibre-opds-php-server
LICENSE = GPLv2

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SERVICE_WIZARD_SHARENAME = wizard_calibre_share

SYSTEM_GROUP = http

ADMIN_URL = /cops/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
endif

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

POST_STRIP_TARGET = cops_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: cops_extra_install
cops_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/cops.conf $(STAGING_DIR)/web/cops.conf
	install -m 644 src/web/cops.json $(STAGING_DIR)/web/cops.json
	@$(MSG) Install default config file
	install -m 666 src/web/config_local.php.synology $(STAGING_DIR)/web/config_local.php.synology

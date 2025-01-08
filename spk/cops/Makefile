SPK_NAME = cops
SPK_VERS = 3.5.4
SPK_REV = 14
SPK_ICON = src/cops.png

DEPENDS  = cross/cops
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 7.2
SPK_DEPENDS = WebStation:PHP8.2:Apache2.4

MAINTAINER = SynoCommunity
DESCRIPTION = Calibre OPDS and HTML PHP Server : light alternative to Calibre content server / Calibre2OPDS.
DESCRIPTION_FRE = Calibre OPDS et HTML PHP Serveur : alternative légère au serveur de contenu de Calibre et à Calibre2OPDS.
DISPLAY_NAME = COPS
CHANGELOG = "1. Update to v3.5.4. (Requires PHP 8.2 and DSM 7.2)"

HOMEPAGE = https://blog.slucas.fr/en/oss/calibre-opds-php-server
LICENSE = GPLv2

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SERVICE_WIZARD_SHARENAME = wizard_calibre_share

SYSTEM_GROUP = http

ADMIN_URL = /cops/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

POST_STRIP_TARGET = cops_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: cops_extra_install
cops_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	@$(MSG) Install default config file
	install -m 666 src/web/config_local.php.synology $(STAGING_DIR)/web/config_local.php.synology

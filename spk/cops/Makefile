SPK_NAME = cops
SPK_VERS = 1.4.2
SPK_REV = 7
SPK_ICON = src/cops.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Calibre OPDS and HTML PHP Server : light alternative to Calibre content server / Calibre2OPDS.
DESCRIPTION_FRE = Calibre OPDS et HTML PHP Serveur : alternative légère au serveur de contenu de Calibre et à Calibre2OPDS.
ADMIN_URL = /cops/
DISPLAY_NAME = COPS
CHANGELOG = "1. Update to 1.4.2<br />2. Upgrade PHP 7.4<br />3. Add .htaccess migration support"

include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

SPK_DEPENDS=WebStation:PHP7.4:Apache2.4

SYSTEM_GROUP = http

HOMEPAGE   = https://blog.slucas.fr/en/oss/calibre-opds-php-server
LICENSE    = GPL

REQUIRED_MIN_DSM = 6.0

DSM_UI_CONFIG = src/app/config

WIZARDS_TEMPLATES_DIR = src/wizard_templates
CONF_DIR = src/conf/

SERVICE_SETUP = src/service-setup.sh
SERVICE_USER = auto
STARTABLE = no

POST_STRIP_TARGET = cops_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

ICON_DIR = $(STAGING_DIR)/$(DSM_UI_DIR)/images

include ../../mk/spksrc.spk.mk

.PHONY: cops_extra_install
cops_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 666 src/config_local.php.synology $(STAGING_DIR)/config_local.php.synology


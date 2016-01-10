SPK_NAME = cops
SPK_VERS = 1.0.0RC3
SPK_REV = 4
SPK_ICON = src/cops.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Calibre OPDS and HTML PHP Server : light alternative to Calibre content server / Calibre2OPDS.
DESCRIPTION_FRE = Calibre OPDS et HTML PHP Serveur : alternative légère au serveur de contenu de Calibre et à Calibre2OPDS.
ADMIN_URL = /cops/
RELOAD_UI = yes
DISPLAY_NAME = COPS
CHANGELOG = "1. Update to 1.0.0RC3"

HOMEPAGE   = http://blog.slucas.fr/en/oss/calibre-opds-php-server
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = cops_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: cops_extra_install
cops_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 666 src/config_local.php.synology $(STAGING_DIR)/config_local.php.synology
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

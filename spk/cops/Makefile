SPK_NAME = cops
SPK_VERS = 1.3.6
SPK_REV = 7
SPK_ICON = src/cops.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Calibre OPDS and HTML PHP Server : light alternative to Calibre content server / Calibre2OPDS.
DESCRIPTION_FRE = Calibre OPDS et HTML PHP Serveur : alternative légère au serveur de contenu de Calibre et à Calibre2OPDS.
ADMIN_URL = /cops/
DISPLAY_NAME = COPS
CHANGELOG = "1. Update to 1.3.6<br />2. Upgrade PHP 8.2 (DSM 7.2+)<br />3. Add .htaccess migration support"

include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

SPK_DEPENDS=WebStation:PHP8.2

SYSTEM_GROUP = http

BETA=1

HOMEPAGE   = https://blog.slucas.fr/en/oss/calibre-opds-php-server
LICENSE    = GPL

REQUIRED_MIN_DSM = 7.0

DSM_UI_CONFIG = src/app/config

WIZARDS_DIR = $(WORK_DIR)/generated-wizards
WIZARDS = install_uifile
CONF_DIR = src/conf/

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

POST_STRIP_TARGET = cops_extra_install

SUPPORTED_LANGUAGES = fre

wizards: generated-wizards

# Pure PHP package, make sure ARCH is not defined
override ARCH=

ICON_DIR = $(STAGING_DIR)/$(DSM_UI_DIR)/images

include ../../mk/spksrc.spk.mk

.PHONY: generated-wizards
generated-wizards:
	@mkdir -p $(WIZARDS_DIR)
	@for template in $(WIZARDS); do \
		for suffix in '' $(patsubst %,_%,$(SUPPORTED_LANGUAGES)) ; do \
			{\
			  	echo "#!/bin/sh";\
				echo "";\
				cat src/wizard_templates/uifile_vars$${suffix} | sed -e 's/\\/\\\\/g' -e 's/\"/\\\"/g' -e 's/^\([^=]*\)=\\"\(.*\)\\"$$/\1="\2"/g';\
				echo "";\
				cat src/wizard_templates/$${template}.sh;\
			}>$(WIZARDS_DIR)/$${template}$${suffix}.sh;\
		done;\
	done

.PHONY: cops_extra_install
cops_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 666 src/config_local.php.synology $(STAGING_DIR)/config_local.php.synology


SPK_NAME = jsmusicdb
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/jsmusicdb.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS =

MAINTAINER = Lucien Immink
DISTRIBUTOR = mysynology.nl
DESCRIPTION = A webstandards based music player with advanced playlist support and an embedded YouTube player. A stand alone version for Windows is also available, please visit http://www.jsmusicdb.com for more info.
DESCRIPTION_NLD = Een webstandaard gebaseerde muziek speler met geavanceerde speellijst ondersteuning en een geintegreerde YouTube-speler. Een stand-alone versie voor Windows is ook beschikbaar, bekijk http://www.jsmusicdb.com voor meer info.
RELOAD_UI = yes
DISPLAY_NAME = JSMusicDB

HOMEPAGE   = http://www.jsmusicdb.com
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = jsmusicdb_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: jsmusicdb_extra_install
jsmusicdb_extra_install: $(STAGING_DIR)/www
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/www/JSMusicDB2/* $(STAGING_DIR)/www

$(STAGING_DIR)/www:
	install -m 755 -d $(STAGING_DIR)/www
	cd $(STAGING_DIR)/www && git clone https://github.com/lucienimmink/JSMusicDB2.git
	rm -fr $(STAGING_DIR)/www/.git $(STAGING_DIR)/www/.gitignore
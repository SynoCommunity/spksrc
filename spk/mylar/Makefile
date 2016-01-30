SPK_NAME = mylar
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 4
SPK_ICON = src/mylar.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = Mylar is an automatic Comic Book downloader \(cbr/cbz\)
DESCRIPTION_FRE = Mylar permet le téléchargement automatique de Comic Book \\\(cbr/cbz\\\)
ADMIN_PORT = 8090
RELOAD_UI = yes
DISPLAY_NAME = Mylar
CHANGELOG = "1. Update to latest<br>2. Enable sc-media group<br>3. Enable built-in updater"

HOMEPAGE   = https://github.com/evilhero/mylar
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = mylar_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: mylar_extra_install
mylar_extra_install: $(STAGING_DIR)/share/mylar
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/mylar:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/evilhero/mylar.git mylar

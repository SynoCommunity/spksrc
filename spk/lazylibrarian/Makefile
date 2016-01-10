SPK_NAME = lazylibrarian
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 4
SPK_ICON = src/lazylibrarian.png
DSM_UI_DIR = app
BETA=1

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = Diaoul
DESCRIPTION = LazyLibrarian is an automated book downloader for SABnzbd.
DESCRIPTION_FRE = LazyLibrarian est un téléchargeur automatique de livre pour SABnzbd.
ADMIN_PORT = 8082
RELOAD_UI = yes
DISPLAY_NAME = LazyLibrarian
CHANGELOG = "1. Use source from DobyTang"

HOMEPAGE   = http://github.com/DobyTang/LazyLibrarian
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = lazylibrarian_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: lazylibrarian_extra_install
lazylibrarian_extra_install: $(STAGING_DIR)/share/LazyLibrarian
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/LazyLibrarian:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone --depth=1 https://github.com/DobyTang/LazyLibrarian.git LazyLibrarian

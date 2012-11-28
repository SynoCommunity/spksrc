SPK_NAME = lazylibrarian
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/lazylibrarian.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-2"

MAINTAINER = SynoCommunity
DESCRIPTION = This project isn\'t finished yet. Goal is to create a SickBeard, CouchPotato, Headphones-like application for ebooks. Headphones is used as a base, so there are still a lot of references to it.
ADMIN_PORT = 5299
RELOAD_UI = yes
DISPLAY_NAME = LazyLibrarian

HOMEPAGE   = https://github.com/itsmegb/LazyLibrarian
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

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
	install -m 755 src/app/lazylibrarian.cgi.py $(STAGING_DIR)/app/lazylibrarian.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/LazyLibrarian:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/itsmegb/LazyLibrarian.git LazyLibrarian
	rm -fr $(STAGING_DIR)/share/LazyLibrarian/.git $(STAGING_DIR)/share/LazyLibrarian/.gitignore

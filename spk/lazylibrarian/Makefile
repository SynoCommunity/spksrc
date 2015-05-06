SPK_NAME = LazyLibrarian
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/lazylibrarian.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = DobyTang
DESCRIPTION = LazyLibrarian is a program to follow authors and grab metadata for all your digital reading needs.
DESCRIPTION_NLD = LazyLibrarian is een programma om schrijvers te volgen en digitale boeken met bijbehorende meta data automatisch te downloaden.
ADMIN_PORT = 5299
RELOAD_UI = yes
DISPLAY_NAME = LazyLibrarian
CHANGELOG = "1. Updated the package installer"

HOMEPAGE   = https://github.com/DobyTang/LazyLibrarian
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/lazylibrarian.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = lazylibrarian_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: lazylibrarian_extra_install
lazylibrarian_extra_install: $(STAGING_DIR)/share/LazyLibrarian
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/lazylibrarian.cgi $(STAGING_DIR)/app/lazylibrarian.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/share/LazyLibrarian/* $(STAGING_DIR)
	rm -R $(STAGING_DIR)/share

$(STAGING_DIR)/share/LazyLibrarian:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/DobyTang/LazyLibrarian.git
	rm -fr $(STAGING_DIR)/share/LazyLibrarian/.git $(STAGING_DIR)/share/LazyLibrarian/.gitignore
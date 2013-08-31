SPK_NAME = couchpotatoserver-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/couchpotatoserver-custom.png
DSM_UI_DIR = app

DEPENDS  = 
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = SynoCommunity
DESCRIPTION = CouchPotato Server Custom allows you to run the fork of your choice of CouchPotato Server. You will be asked for the fork\'s git URL during install.
DESCRIPTION_FRE = CouchPotato Server Custom vous permet d\\\'exécuter le fork de votre choix de CouchPotato Server. Vous aurez besoin de saisir l\\\'URL git du fork durant l\\\'installation.
ADMIN_PORT = 5053
RELOAD_UI = yes
DISPLAY_NAME = CouchPotato Server Custom

HOMEPAGE   = http://couchpota.to/
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = couchpotatoservercustom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: couchpotatoservercustom_extra_install
couchpotatoservercustom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/settings.conf $(STAGING_DIR)/var/settings.conf
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

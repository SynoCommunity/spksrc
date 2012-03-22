SPK_NAME = umurmur
SPK_VERS = 0.2.9
SPK_REV = 1
SPK_ICON = src/umurmur.png
DSM_UI_DIR = app

DEPENDS = cross/openssl cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Minimalistic Mumble server
DESCRIPTION_FRE = Serveur Mumble minimaliste
RELOAD_UI = yes
DISPLAY_NAME = uMurmur

HOMEPAGE   = http://code.google.com/p/umurmur/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = umurmur_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: umurmur_extra_install
umurmur_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/umurmur.conf $(STAGING_DIR)/var/umurmur.conf
	install -m 755 -d $(STAGING_DIR)/sbin
	install -m 755 src/gencert.sh $(STAGING_DIR)/sbin/gencert.sh
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/umurmur.cgi.pl $(STAGING_DIR)/app/umurmur.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done


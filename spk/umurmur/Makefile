

SPK_NAME = umurmur
SPK_VERS = 0.2.8
SPK_REV = 1
SPK_ICON = src/umurmur.png

DEPENDS = cross/openssl cross/$(SPK_NAME)

MAINTAINER = http://packages.nas-forum.com
COMMENT    = Minimalistic Mumble server
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
	install -m 755 -d $(STAGING_DIR)/share/synoman
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/sbin
	install -m 644 src/config.json $(STAGING_DIR)/share/synoman/config
	install -m 755 src/umurmur.cgi.pl $(STAGING_DIR)/share/synoman/umurmur.cgi
	install -m 644 src/umurmur.conf $(STAGING_DIR)/etc/umurmur.conf
	install -m 755 src/gencert.sh $(STAGING_DIR)/sbin/gencert.sh
	mv $(STAGING_DIR)/openssl.cnf $(STAGING_DIR)/var/openssl.cnf
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} -transparent white \
	            $(STAGING_DIR)/share/synoman/umurmur-$${size}.png ; \
	done

SPK_NAME = transmission
SPK_VERS = 2.42
SPK_REV = 1
SPK_ICON = src/transmission.png

DEPENDS = cross/$(SPK_NAME) cross/xzdec-static cross/busybox

MAINTAINER = SynoCommunity
COMMENT    = "A Fast, Easy, and Free BitTorrent Client"
ADMIN_PORT = 9091
RELOAD_UI = yes
DISPLAY_NAME = Transmission

HOMEPAGE   = http://www.transmissionbt.com/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = xz-compress

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	install -m 755 -d $(STAGING_DIR)/share/synoman
	install -m 644 src/config.json $(STAGING_DIR)/share/synoman/config
	install -m 755 src/transmission.cgi.sh $(STAGING_DIR)/share/synoman/transmission.cgi
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} -transparent white \
	            $(STAGING_DIR)/share/synoman/Transmission-$${size}.png ; \
	done
	mv $(STAGING_DIR)/bin/xzdec $(WORK_DIR)/xzdec
	(cd $(STAGING_DIR) && tar cpJf $(WORK_DIR)/package.txz --group=root --owner=root *)
	rm -fr $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mv $(WORK_DIR)/package.txz $(STAGING_DIR)/
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 $(WORK_DIR)/xzdec $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/settings.json $(STAGING_DIR)/var/


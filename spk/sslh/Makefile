

SPK_NAME = sslh
SPK_VERS = 1.9
SPK_REV = 2
SPK_ICON = src/sslh.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = packages@packages.nas-forum.com
COMMENT    = sslh accepts HTTPS, SSH, OpenVPN and Tinc connections on the same port.
RELOAD_UI = no
DISPLAY_NAME = SSLH

HOMEPAGE   = http://www.rutschle.net/tech/sslh.shtml
LICENSE    = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/start-stop-status
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
POST_STRIP_TARGET = xz-compress

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	install -m 755 -d $(STAGING_DIR)/log
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/*.pl $(STAGING_DIR)/bin/
	install -m 644 src/sslh.ini $(STAGING_DIR)/sslh.ini
	install -m 755 -d $(STAGING_DIR)/www
	install -m 755 src/www/*.cgi $(STAGING_DIR)/www/
	install -m 644 src/www/*.css $(STAGING_DIR)/www/
	install -m 644 src/www/*.html $(STAGING_DIR)/www/
	install -m 644 src/www/*.js $(STAGING_DIR)/www/
	install -m 644 src/www/config $(STAGING_DIR)/www/
	install -m 755 -d $(STAGING_DIR)/www/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} -transparent white \
	            $(STAGING_DIR)/www/images/icon$${size}.png ; \
	done	
	chmod 644 $(STAGING_DIR)/www/images/i*.png

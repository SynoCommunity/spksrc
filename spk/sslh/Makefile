SPK_NAME = sslh
SPK_VERS = 1.13b
SPK_REV = 1
SPK_ICON = src/sslh.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = sslh accepts HTTPS, SSH, OpenVPN, tinc and XMPP connections on the same port. This makes it possible to connect to any of these servers on port 443 \(e.g. from inside a corporate firewall, which almost never block port 443\) while still serving HTTPS on that port.
DESCRIPTION_FRE = sslh accepte des connexions HTTPS, SSH, OpenVPN, tinc et XMPP sur le même port TCP. Il est ainsi possible de se connecter à l\\\'un de ces services sur le port 443 \\\(par exemple depuis derrière un firewall d\\\'entrepise qui ne bloque en général pas le port 443\\\) tout en préservant les accès HTTPS sur ce même port.
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

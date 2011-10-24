

SPK_NAME = tinyproxy
SPK_VERS = 1.8.3
SPK_REV = 1
SPK_ICON = src/tinyproxy.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = packages@packages.nas-forum.com
COMMENT    = "Tinyproxy is a light-weight HTTP/HTTPS proxy daemon for POSIX operating systems."
RELOAD_UI = no
DISPLAY_NAME = Tinyproxy

HOMEPAGE   = https://banu.com/tinyproxy/
LICENSE    = GNU GPL 2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/start-stop-status
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PRE_COPY_TARGET = install-tinyproxy
COPY_TARGET = copy_target_tinyproxy

include ../../mk/spksrc.spk.mk

copy_target_tinyproxy:

.PHONY: install-tinyproxy
install-tinyproxy:
	@$(MSG) "=========== PACKAGING TINYPROXY ===================="
	install -m 755 -d $(STAGING_DIR)/log
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 src/bin/*.pl $(STAGING_DIR)/bin/
	install -m 755 $(INSTALL_DIR)/usr/local/tinyproxy/sbin/tinyproxy $(STAGING_DIR)/bin/
	install -m 644 src/tinyproxy.conf $(STAGING_DIR)/tinyproxy.conf
	install -m 644 src/tinyproxy.conf.tpl $(STAGING_DIR)/tinyproxy.conf.tpl
	install -m 644 $(INSTALL_DIR)/usr/local/tinyproxy/share/tinyproxy/* $(STAGING_DIR)/share/
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
	chmod 644 $(STAGING_DIR)/www/images/*.png

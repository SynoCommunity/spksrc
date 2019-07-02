SPK_NAME = squidguard
SPK_VERS = 1.5
SPK_REV = 1
SPK_ICON = src/squidguard.png
BETA = 1

DEPENDS = cross/zlib cross/c_icap cross/busybox cross/unrar cross/squidclamav cross/berkeleydb cross/squidguard cross/squid cross/squidguardmanager

SPK_DEPENDS = "AntiVirus>1.2"

MAINTAINER = SynoCommunity
DESCRIPTION = SquidGuard is a URL redirector used to use blacklists with the proxysoftware Squid. This package also includes SquidClamav for viruses protection and SquidGuard Manager.
DESCRIPTION_FRE = SquidGuard est un proxy HTTP, basé sur squid, qui permet de filtrer les accès selon une liste noire. Ce paquet contient également SquidClamav pour une protection antivirus et SquidGuard Manager.
RELOAD_UI = no
DISPLAY_NAME = SquidGuard

HOMEPAGE   = http://www.squidguard.org/
LICENSE    = GNU PL - Copyright © 1990,2007 Oracle.  All rights reserved for berkeley db library. See LICENSE file.

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
POST_STRIP_TARGET = xz-compress

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/libexec
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 -d $(STAGING_DIR)/share/c_icap/templates/
	install -m 755 -d $(STAGING_DIR)/share/icons
	install -m 755 -d $(STAGING_DIR)/share/errors
	install -m 755 -d $(STAGING_DIR)/var/logs
	install -m 755 -d $(STAGING_DIR)/var/run/c-icap
	install -m 755 -d $(STAGING_DIR)/var/run/clamd
	install -m 755 -d $(STAGING_DIR)/var/cache
	install -m 755 -d $(STAGING_DIR)/var/db
	install -m 755 src/update_db.sh $(STAGING_DIR)/bin/
	install -m 755 src/etc/* $(STAGING_DIR)/etc/
	install -m 644 src/app/config $(STAGING_DIR)/share/www/squidguardmgr/
	install -m 755 src/app/squidGuard.cgi $(STAGING_DIR)/share/www/squidguardmgr/
	install -m 644 src/app/babel.* $(STAGING_DIR)/share/www/squidguardmgr/
	install -m 644 src/app/synocommunity.png $(STAGING_DIR)/share/www/squidguardmgr/
	install -m 644 src/app/blocked.gif $(STAGING_DIR)/share/www/squidguardmgr/
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} -transparent white -strip \
	            $(STAGING_DIR)/share/www/squidguardmgr/images/icon$${size}.png ; \
	done	
	chmod 644 $(STAGING_DIR)/share/www/squidguardmgr/images/i*.png


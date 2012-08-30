SPK_NAME = squidguard
SPK_VERS = 1.00
SPK_REV = 1
SPK_ICON = src/squidguard.png
BETA = 1

DEPENDS = cross/busybox cross/berkeleydb cross/squidguard cross/squid

MAINTAINER = SynoCommunity
DESCRIPTION = SquidGuard is a URL redirector used to use blacklists with the proxysoftware Squid.
DESCRIPTION_FRE = SquidGuard est un proxy HTTP, basé sur squid, qui permet de filtrer les accès selon une liste noire.
RELOAD_UI = no
DISPLAY_NAME = SquidGuard

HOMEPAGE   = http://www.squidguard.org/
LICENSE    = GNU PL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
POST_STRIP_TARGET = xz-compress

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/libexec
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 -d $(STAGING_DIR)/share/icons
	install -m 755 -d $(STAGING_DIR)/share/errors
	install -m 755 -d $(STAGING_DIR)/var/logs
	install -m 755 -d $(STAGING_DIR)/var/run
	install -m 755 -d $(STAGING_DIR)/var/cache
	install -m 755 -d $(STAGING_DIR)/var/db
	install -m 755 -d $(STAGING_DIR)/var/db
	install -m 755 src/update_db.sh $(STAGING_DIR)/bin/
	install -m 755 src/etc/* $(STAGING_DIR)/etc/


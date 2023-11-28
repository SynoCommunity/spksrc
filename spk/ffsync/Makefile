SPK_NAME = ffsync
SPK_VERS = 0.14.1
SPK_REV = 4
SPK_ICON = src/ffsync.png

BUILD_DEPENDS = cross/curl cross/mysql-connector-c
DEPENDS     = cross/syncstorage-rs

PYTHON_PACKAGE = python311
WHEELS      = src/requirements.txt

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = MariaDB10:python311

MAINTAINER   = SynoCommunity
DESCRIPTION  = Firefox Sync Server 1.5, used for Firefox 29 and later. You can use Firefox Sync Server to synchronize your bookmarks, passwords, settings, history, add-ons and tabs with Firefox on other computers. The service runs on port 8132.
DISPLAY_NAME = Firefox Sync Server 1.5
CHANGELOG = "1. Upgrade to Mozilla Sync Storage built with Rust."

HOMEPAGE     = https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html
LICENSE      = MPL-2.0
HELPURL      = https://github.com/SynoCommunity/spksrc/wiki/Firefox-Sync-Server-1.5

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8132
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

CONF_DIR         = src/conf/

# [mysqlclient]
DEPENDS += cross/mysql-connector-c cross/mariadb-connector-c
ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

# [bcrypt] and [cryptography]
# Mandatory for rustc wheel building
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
ENV += CRYPTOGRAPHY_DONT_BUILD_RUST=1

POST_STRIP_TARGET = ffsync_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ffsync_extra_install
ffsync_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/ffsync.ini $(STAGING_DIR)/var/

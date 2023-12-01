SPK_NAME = ffsync
SPK_VERS = 0.14.3
SPK_REV = 4
SPK_ICON = src/ffsync.png

BUILD_DEPENDS = cross/curl cross/mysql-connector-c
DEPENDS     = cross/syncstorage-rs

PYTHON_PACKAGE = python311
WHEELS      = src/requirements-crossenv.txt src/requirements-pure.txt

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = MariaDB10:$(PYTHON_PACKAGE)

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

POST_STRIP_TARGET = ffsync_extra_install

include ../../mk/spksrc.python.mk

.PHONY: ffsync_extra_install
ffsync_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/var/local.toml $(STAGING_DIR)/var/

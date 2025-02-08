SPK_NAME = ffsync
SPK_VERS = 0.18.2
SPK_REV = 4
SPK_ICON = src/ffsync.png

DEPENDS = cross/syncstorage-rs cross/diesel

PYTHON_PACKAGE = python311
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = MariaDB10:$(PYTHON_PACKAGE)

MAINTAINER = SynoCommunity
DESCRIPTION = An implementation of the Mozilla Sync-1.5 Server protocol used by the sync service in Firefox 29 and later. You can use Mozilla Sync Server to exchange browser data \(bookmarks, history, open tabs, passwords, add-ons, and the like\) between \'clients\' in a manner that respects a user\'s security and privacy. The service runs on port 8132.
DISPLAY_NAME = Mozilla Sync Server
CHANGELOG = "Update Mozilla Sync Server package to v0.18.2."

HOMEPAGE = https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html
LICENSE = MPL 2.0

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8132
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

# [cryptography]
DEPENDS += cross/openssl3

# [mysqlclient]
ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

POST_STRIP_TARGET = ffsync_extra_install

include ../../mk/spksrc.python.mk

# [greenlet]
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
WHEELS += src/requirements-crossenv-greenlet-v2.txt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
endif
else
WHEELS += src/requirements-crossenv-greenlet-v1.txt
endif


.PHONY: ffsync_extra_install
ffsync_extra_install:
	@$(MSG) Install config file
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/var/local.toml $(STAGING_DIR)/var/
	@$(MSG) Patch binaries built with rust to find shared libraries
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib:/var/packages/$(PYTHON_PACKAGE)/target/lib $(STAGING_DIR)/bin/syncserver
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/diesel

SPK_NAME = ffsync
SPK_VERS = 0.21.1
SPK_REV = 9
SPK_ICON = src/ffsync.png

DEPENDS = cross/syncstorage-rs cross/diesel

PYTHON_PACKAGE = python312
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS) $(ARMv7L_ARCHS)

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = MariaDB10:$(PYTHON_PACKAGE)
# SRM is not supported due lacking mariadb package
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = An implementation of the Mozilla Sync-1.5 Server protocol used by the sync service in Firefox 29 and later. You can use Mozilla Sync Server to exchange browser data \(bookmarks, history, open tabs, passwords, add-ons, and the like\) between \'clients\' in a manner that respects a user\'s security and privacy. The service runs on port 8132.
DISPLAY_NAME = Mozilla Sync Server
CHANGELOG = "1. Update Mozilla Sync Server package to v0.21.1."

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
ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

POST_STRIP_TARGET = ffsync_extra_install

include ../../mk/spksrc.python.mk

# [greenlet]
# version >= 3.1: gcc >= 8   (DSM7.1) Mandatory require full c++20 support
# version  = 3.0: gcc >= 4.9 (DSM6, comcerto2k) Mandatory require full c++11 support
# version  = 1.x: gcc <  4.9 (DSM5, DSM6) Last known working version (armv5, hi3535) *** unsupported ***
ifeq ($(call version_ge, $(TC_GCC), 8),1)
WHEELS += greenlet==3.2.4
else ifeq ($(call version_ge, $(TC_GCC), 4.9)$(call version_lt, $(TC_GCC), 5.0),11)
WHEELS += greenlet==3.0.3
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
endif

.PHONY: ffsync_extra_install
ffsync_extra_install:
	@$(MSG) Install config file
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/var/local.toml $(STAGING_DIR)/var/
	@$(MSG) Patch binaries built with rust to find shared libraries
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib:/var/packages/$(PYTHON_PACKAGE)/target/lib $(STAGING_DIR)/bin/syncserver
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/diesel

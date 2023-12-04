SPK_NAME = ffsync
SPK_VERS = 0.14.3
SPK_REV = 1
SPK_ICON = src/ffsync.png

DEPENDS = cross/syncstorage-rs cross/diesel

PYTHON_PACKAGE = python311
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = MariaDB10:$(PYTHON_PACKAGE)

MAINTAINER = SynoCommunity
DESCRIPTION  = Firefox Sync Server 1.5, used for Firefox 29 and later. You can use Firefox Sync Server to synchronize your bookmarks, passwords, settings, history, add-ons and tabs with Firefox on other computers. The service runs on port 8132.
DISPLAY_NAME = Firefox Sync Server 1.5
CHANGELOG = "Inital Mozilla Sync Storage package."

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
# Mandatory of using OPENSSL_*_DIR starting with version >= 40
# https://docs.rs/openssl/latest/openssl/#automatic
DEPENDS += cross/openssl3
ENV += OPENSSL_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += OPENSSL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

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

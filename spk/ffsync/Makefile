SPK_NAME = ffsync
SPK_VERS = 0.22.3
SPK_REV = 11
SPK_ICON = src/ffsync.png

DEPENDS = cross/syncstorage-rs cross/diesel

PYTHON_PACKAGE = python312
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS) $(ARMv7L_ARCHS)
# aarch64-6.2.4 excluded: aws-lc-sys (used by rustls in syncstorage-rs 0.22.x) requires ARMv8.2+ crypto
# instructions not available on older Synology ARM CPUs (e.g., Alpine.4x, Alpine.4xL, RT1900acv1, etc.)
UNSUPPORTED_ARCHS_TCVERSION = aarch64-6.2.4

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = MariaDB10
# SRM is not supported due lacking mariadb package
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = An implementation of the Mozilla Sync-1.5 Server protocol used by the sync service in Firefox 29 and later. You can use Mozilla Sync Server to exchange browser data \(bookmarks, history, open tabs, passwords, add-ons, and the like\) between \'clients\' in a manner that respects a user\'s security and privacy. The service runs on port 8132.
DISPLAY_NAME = Mozilla Sync Server
CHANGELOG = "1. Update Mozilla Sync Server package to v0.22.3."

HOMEPAGE = https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html
LICENSE = MPL 2.0

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8132
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# No admin UI - sync server is accessed via client applications (Firefox, etc.)
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = ffsync_extra_install

include ../../mk/spksrc.common.mk

# [cryptography]
DEPENDS += cross/openssl3

.PHONY: ffsync_extra_install
ffsync_extra_install:
	@$(MSG) Install config file
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/var/local.toml $(STAGING_DIR)/var/
	@$(MSG) Patch binaries built with rust to find shared libraries
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib:/var/packages/$(PYTHON_PACKAGE)/target/lib $(STAGING_DIR)/bin/syncserver
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/diesel

include ../../mk/spksrc.spk-meta.mk

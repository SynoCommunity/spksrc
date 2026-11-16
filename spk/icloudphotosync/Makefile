SPK_NAME = icloudphotosync
SPK_VERS = 1.4.4
SPK_REV  = 1
SPK_ICON = src/PACKAGE_ICON.PNG

DEPENDS  = cross/python311
DEPENDS += cross/heif-convert

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER     = Pascal Pagel
DESCRIPTION    = Automatically mirrors your iCloud photo library to a Synology NAS. Supports multi-account setups, incremental sync, album selection, HEIC conversion, and scheduled operation.
DISPLAY_NAME   = iCloud Photo Sync
CHANGELOG      = Security hardening: CSRF protection, DSM session auth gate, rate limiting, path traversal prevention, SSRF fix, symlink-safe file ops, encrypted 2FA password storage, restrictive file permissions.

HOMEPAGE   = https://github.com/Euphonique/iCloudPhotoSync
LICENSE    = MIT

REQUIRED_MIN_DSM = 7.2
SERVICE_USER     = auto
STARTABLE        = yes
SERVICE_SETUP    = src/service-setup.sh

SERVICE_PORT       = 0
SERVICE_PORT_TITLE = iCloud Photo Sync

DSM_UI_DIR = app

SPK_COMMANDS  = bin/scheduler.py
SPK_COMMANDS += bin/sync_runner.py
SPK_COMMANDS += bin/move_runner.py

WHEELS = src/requirements-pure.txt

POST_STRIP_TARGET = icloudphotosync_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: icloudphotosync_extra_install
icloudphotosync_extra_install:
	@$(MSG) Installing iCloudPhotoSync application files
	@install -d -m 755 $(STAGING_DIR)/bin
	@install -d -m 755 $(STAGING_DIR)/lib
	@install -d -m 755 $(STAGING_DIR)/app
	@install -m 755 src/bin/scheduler.py $(STAGING_DIR)/bin/
	@install -m 755 src/bin/sync_runner.py $(STAGING_DIR)/bin/
	@install -m 755 src/bin/move_runner.py $(STAGING_DIR)/bin/
	@cp -R src/lib/*.py $(STAGING_DIR)/lib/
	@cp -R src/lib/handlers $(STAGING_DIR)/lib/
	@cp -R src/lib/vendor $(STAGING_DIR)/lib/
	@cp -R src/app/* $(STAGING_DIR)/app/
	@install -d -m 755 $(STAGING_DIR)/conf
	@cp src/conf/privilege $(STAGING_DIR)/conf/
	@cp src/conf/resource $(STAGING_DIR)/conf/

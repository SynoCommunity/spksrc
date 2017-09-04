SPK_NAME = syncthing-inotify
SPK_VERS = 0.8.5
SPK_REV = 2
SPK_ICON = src/${SPK_NAME}.png
BETA = 1

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "syncthing>=0.14.23-11"
START_DEP_SERVICES = syncthing

MAINTAINER = o0v7r0o
DESCRIPTION = File watcher intended for use with Syncthing. Syncthing uses a rescan interval to detect changes in folders. Syncthing-inotify uses OS primitives to detect changes as soon as they happen. Therefore, near real-time synchronisation can be achieved.
RELOAD_UI = no
DISPLAY_NAME = Syncthing-Inotify
CHANGELOG = "Update to 0.8.5"
HOMEPAGE = https://github.com/syncthing/syncthing-inotify
LICENSE = MPL-2.0

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = inotify_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: inotify_extra_install
inotify_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/options.conf $(STAGING_DIR)/var/options.conf

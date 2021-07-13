SPK_NAME = watcher3
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/${SPK_NAME}.png
DSM_UI_DIR = app

DEPENDS =
SPK_DEPENDS = "python3>=3.4.1-4:git"

MAINTAINER = Fredrike
DESCRIPTION = "Watcher is an automated movie NZB & Torrent searcher and snatcher. You can add a list of wanted movies and Watcher will automatically send the NZB or Torrent to your download client. Watcher also has basic post-processing capabilities such as renaming and moving."
ADMIN_PORT = 9090
RELOAD_UI = yes
DISPLAY_NAME = Watcher3

HOMEPAGE   = https://nosmokingbandit.github.io/
LICENSE    = Apache License 2.0

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = watcher3_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: watcher3_extra_install
watcher3_extra_install: $(STAGING_DIR)/share/Watcher3
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.cfg $(STAGING_DIR)/var/config.cfg
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/logs
	install -m 644 src/app/config $(STAGING_DIR)/app/config

$(STAGING_DIR)/share/Watcher3:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone --depth=1 https://github.com/nosmokingbandit/Watcher3.git Watcher3

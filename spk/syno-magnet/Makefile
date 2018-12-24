SPK_NAME = SynoMagnet
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/magnet.png

DEPENDS =
SPK_DEPENDS = 

MAINTAINER = neykov
DESCRIPTION = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
DISPLAY_NAME = Download Station Magnet
CHANGELOG = "Initial Version"

HOMEPAGE   = http://github.com/neykov/syno-magnet
LICENSE    = Apache 2.0
STARTABLE  = no

DSM_UI_DIR = app

COPY_TARGET = nop
POST_STRIP_TARGET = syno_magnet_install

# Pure web package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: syno_magnet_install
syno_magnet_install:
	install -m 755 -d $(STAGING_DIR)/app
	git clone --depth=1 --branch v1.0 https://github.com/neykov/syno-magnet.git $(STAGING_DIR)/app

SPK_NAME = tekkitlite
SPK_VERS = 0.6.1
SPK_REV = 018
SPK_ICON = src/tekkitlite.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS =

MAINTAINER = SynoCommunity
DESCRIPTION = A new Tekkit is here! One geared for smaller servers and that takes avantage of the new way Minecraft handles multiplayer and arising out of the chaos that is the forgebukkit fiasco, we present Tekkit Lite.
ADMIN_PORT = 
RELOAD_UI = yes
DISPLAY_NAME = Tekkit Lite
BETA = 

HOMEPAGE   = http://technicpack.net/
LICENSE    = 

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = extra_install

# Pure Java package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: extra_install
extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/index.cgi $(STAGING_DIR)/app/index.cgi
	install -m 755 src/app/logFunctions.cgi $(STAGING_DIR)/app/logFunctions.cgi
	install -m 644 src/app/page.html $(STAGING_DIR)/app/page.html
	install -m 644 src/app/script.js $(STAGING_DIR)/app/script.js
	install -m 755 -d $(STAGING_DIR)/app/icons
	install -m 644 src/app/icons/icon.png $(STAGING_DIR)/app/icons/icon.png
	install -m 644 src/app/icons/icon_16.png $(STAGING_DIR)/app/icons/icon_16.png
	install -m 644 src/app/icons/icon_24.png $(STAGING_DIR)/app/icons/icon_24.png
	install -m 644 src/app/icons/icon_32.png $(STAGING_DIR)/app/icons/icon_32.png
	install -m 644 src/app/icons/icon_48.png $(STAGING_DIR)/app/icons/icon_48.png
	#And to do something different, copy the launcher stright into the scripts folder
	install -m 755 -d $(WORK_DIR)/scripts
	install -m 755 src/scripts/launcher.sh $(WORK_DIR)/scripts/launcher.sh


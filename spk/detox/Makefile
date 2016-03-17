SPK_NAME = detox
SPK_VERS = 1.2.0
SPK_REV = 1
SPK_ICON = src/detox.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Feeditout
DESCRIPTION = Detox is a utility designed to clean up filenames. It replaces difficult to work with characters, such as spaces, with standard equivalents.
RELOAD_UI = no
DISPLAY_NAME = Detox
STARTABLE = no
BETA = 1
CHANGELOG = "Initial Release"

HOMEPAGE   = http://detox.sourceforge.net/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
POST_STRIP_TARGET = detox-files

include ../../mk/spksrc.spk.mk

.PHONY: detox-files
detox-files:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 src/etc/* $(STAGING_DIR)/etc/


SPK_NAME = he853
SPK_VERS = 1.0.0
SPK_REV  = 1
SPK_ICON = src/HE853.png

DEPENDS = cross/$(SPK_NAME)
REQUIRED_DSM = 5.0

MAINTAINER = SynoCommunity
DESCRIPTION = HomeEasy HE853 USB device executable - https://github.com/hphde/he853-cli - Allows usage of 433MHz HomeEasy and Smartwares devices from your NAS.
RELOAD_UI = no
DISPLAY_NAME = HomeEasy HE853 USB device executable
STARTABLE = no
CHANGELOG = "Initial release"
BETA = 1

MAINTAINER = hphde
HOMEPAGE   = https://github.com/hphde/he853-cli
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

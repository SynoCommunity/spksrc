SPK_NAME = shairport
SPK_VERS = 1.1.1
SPK_REV = 1
SPK_ICON = src/shairport.png

DEPENDS =  cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Use Synology NAS as an AirPlay receiver. Requires USB soundcard or speakers.
RELOAD_UI = no
DISPLAY_NAME = ShairPort
CHANGELOG = "Initial SynoCommunity Release"

HOMEPAGE = https://github.com/abrasive/shairport
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

SPK_NAME = get_iplayer
SPK_VERS = 2.83
SPK_REV = 1
SPK_ICON = src/getiplayer.png

DEPENDS = cross/rtmpdump cross/$(SPK_NAME)
SPK_DEPENDS = "Perl"

MAINTAINER = SynoCommunity
DESCRIPTION = get_iplayer allows you to search, index and record/stream BBC iPlayer radio and TV.
STARTABLE = no
DISPLAY_NAME = get_iplayer
BETA = 1

HOMEPAGE = http://www.infradead.org/get_iplayer/html/get_iplayer.html
LICENSE  = GPLv3+

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

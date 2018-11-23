SPK_NAME = nmap
SPK_VERS = 7.40
SPK_REV = 1
SPK_ICON = src/nmap.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = nmap is a network security scanner, used to discover hosts and services on a computer network, thus building a "map" of the network.
DESCRIPTION_FRE = nmap est un scanneur de vulnérabilités réseau, utilisé pour découvrir des machines et services sur un réseau, et ainsi contruire la "carte" du réseau.
RELOAD_UI = no
DISPLAY_NAME = nmap
STARTABLE = no
BETA = 1
CHANGELOG = "Initial release"

HOMEPAGE   = http://nmap.org
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

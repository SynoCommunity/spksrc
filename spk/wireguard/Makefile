SPK_NAME = wireguard
SPK_VERS = 0.0.20190227
SPK_REV = 0
SPK_ICON = src/wireguard.png

DEPENDS = cross/$(SPK_NAME)
UNSUPPORTED_ARCHES = $(PPC_ARCHES)

MAINTAINER = publicarray
DESCRIPTION  = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
DISPLAY_NAME = WireGuard
HELPURL = https://www.wireguard.com
LICENSE = GPLv2

STARTABLE = no

SERVICE_SETUP = src/service-setup.sh
include ../../mk/spksrc.spk.mk

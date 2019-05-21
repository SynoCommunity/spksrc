SPK_NAME = wireguard
SPK_VERS = 0.0.20190406
SPK_REV = 0
SPK_ICON = src/wireguard.png

DEPENDS = cross/bash cross/$(SPK_NAME)
UNSUPPORTED_ARCHES = $(PPC_ARCHES)

MAINTAINER = publicarray
DESCRIPTION  = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
DISPLAY_NAME = WireGuard
HELPURL = https://www.wireguard.com
LICENSE = GPLv2

FWPORTS = src/${SPK_NAME}.sc
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER = auto
STARTABLE = yes

include ../../mk/spksrc.spk.mk

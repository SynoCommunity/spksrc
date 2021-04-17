SPK_NAME = wireguard
SPK_VERS = 1.0.20210219
SPK_REV = 1
SPK_ICON = src/wireguard.png

DEPENDS = cross/$(SPK_NAME)-linux-compat cross/$(SPK_NAME)-tools
UNSUPPORTED_ARCHES = $(PPC_ARCHES)

include ../../mk/spksrc.archs.mk
# SRM has ash as a shell
ifeq ($(findstring $(ARCH),$(SRM_ARMv7_ARCHS)),$(ARCH))
DEPENDS += cross/bash
endif

MAINTAINER = publicarray
DESCRIPTION  = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
DISPLAY_NAME = WireGuard
HELPURL = https://www.wireguard.com
LICENSE = GPLv2

FWPORTS = src/$(SPK_NAME).sc

STARTABLE = no
SYSTEM_GROUP = system
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 51820
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

SPK_COMMANDS += bin/wg
SPK_COMMANDS += bin/wg-quick

include ../../mk/spksrc.spk.mk

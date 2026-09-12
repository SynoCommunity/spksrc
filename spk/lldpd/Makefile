SPK_NAME = lldpd
SPK_VERS = 1.0.18
SPK_REV = 1
SPK_ICON = src/lldpd.png

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

DEPENDS = cross/lldpd

MAINTAINER = SynoCommunity
DESCRIPTION = LLDP \(Link Layer Discovery Protocol\) is an industry standard protocol designed to supplant proprietary Link-Layer protocols such as Extreme's EDP \(Extreme Discovery Protocol\) and CDP \(Cisco Discovery Protocol\). The goal of LLDP is to provide an inter-vendor compatible mechanism to deliver Link-Layer notifications to adjacent network devices.
DISPLAY_NAME = lldpd
CHANGELOG = "Initial package release."

HOMEPAGE = https://lldpd.github.io
LICENSE  = ISC

SERVICE_USER = auto
STARTABLE = yes

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = bin/lldpcli bin/lldpctl

include ../../mk/spksrc.spk.mk

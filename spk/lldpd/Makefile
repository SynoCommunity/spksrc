SPK_NAME = lldpd
SPK_VERS = 1.0.10
SPK_REV = 1
SPK_ICON = src/lldpd.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = LLDP (Link Layer Discovery Protocol) is an industry standard protocol designed to supplant proprietary Link-Layer protocols such as Extreme's EDP (Extreme Discovery Protocol) and CDP (Cisco Discovery Protocol). The goal of LLDP is to provide an inter-vendor compatible mechanism to deliver Link-Layer notifications to adjacent network devices.
DISPLAY_NAME = lldpd
CHANGELOG = "Initial release"

HOMEPAGE = https://lldpd.github.io
LICENSE  = ISC

CONF_DIR = src/conf
SERVICE_USER = sc-lldpd
STARTABLE  = yes

POST_STRIP_TARGET = lldpd_extra_install

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = sbin/lldpcli sbin/lldpctl

include ../../mk/spksrc.spk.mk

.PHONY: lldpd_extra_install
lldpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/run

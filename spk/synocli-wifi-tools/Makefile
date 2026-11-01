SPK_NAME = synocli-wifi-tools
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/SynoPackagegreen-wifi.png

DEPENDS  = cross/iw
# WPA3 and a DHCP client of its own: DSM's wpa_supplicant 2.6 has neither SAE nor
# PMF, and its dhclient runs no script but its own
DEPENDS += cross/wpa_supplicant
DEPENDS += cross/busybox

# The WiFi adapters of synokernel-wifi, which SRM, DSM 5 and kernels before 3.2
# leave out
UNSUPPORTED_ARCHS = $(SRM_ARCHS) $(ARMv5_ARCHS) $(PPC_ARCHS)
REQUIRED_MIN_DSM = 6.0

MAINTAINER    = th0ma7
DESCRIPTION   = "SynoCli WiFi Tools provides the command-line tools to connect a NAS to a WiFi network with the adapters of synokernel-wifi: iw, wpa_supplicant 2.11 with WPA3, the DHCP client udhcpc, and synocli-wifi, which connects by network profile."
DISPLAY_NAME  = SynoCli WiFi Tools
STARTABLE     = no
WIZARDS_DIR   = src/wizard/
CHANGELOG     = "1. Initial release"

HOMEPAGE = https://docs.synocommunity.com/packages/synocli-wifi-tools/
LICENSE  = Each tool is licensed under it\'s respective license.

# synocli-kernelmodule loads the driver of the adapter
SPK_DEPENDS = "synocli-kernel>=2.0-12"

SPK_COMMANDS  = bin/synocli-wifi
SPK_COMMANDS += sbin/iw
SPK_COMMANDS += sbin/udhcpc
# Under names of their own: DSM's wpa_supplicant 2.6 comes first in the PATH of root
SPK_COMMANDS += sbin/wifi-wpa_supplicant
SPK_COMMANDS += sbin/wifi-wpa_cli
SPK_COMMANDS += sbin/wifi-wpa_passphrase

BUSYBOX_CONFIG = udhcpc
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

SERVICE_SETUP = src/service-setup.sh
POST_STRIP_TARGET = synocli-wifi-tools_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synocli-wifi-tools_extra_install
synocli-wifi-tools_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin $(STAGING_DIR)/etc
	install -m 755 src/synocli-wifi.sh $(STAGING_DIR)/bin/synocli-wifi
	install -m 755 src/udhcpc.script $(STAGING_DIR)/etc/udhcpc.script
	ln -sf ../bin/busybox $(STAGING_DIR)/sbin/udhcpc
	for tool in wpa_supplicant wpa_cli wpa_passphrase; do \
	  ln -sf $$tool $(STAGING_DIR)/sbin/wifi-$$tool ; \
	done

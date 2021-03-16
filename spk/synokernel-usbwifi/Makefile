SPK_NAME = synokernel-usbwifi
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png
CHANGELOG = "1. Synology Kernel Wireless drivers"

DEPENDS = cross/rtl8812au cross/rtl8814au

ifeq ($(strip $(TC_TYPE)),DSM)
REQUIRED_DSM = 6.2.3
else ifeq ($(strip $(TC_TYPE)),SRM)
REQUIRED_SRM = 1.2
endif

REQUIRE_KERNEL = 1
REQUIRE_KERNEL_MODULE  = CONFIG_CFG80211:net/wireless:cfg80211
REQUIRE_KERNEL_MODULE += CONFIG_MAC80211:net/mac80211:mac80211
REQUIRE_KERNEL_MODULE += CONFIG_AT76C50X_USB:drivers/net/wireless:at76c50x-usb
REQUIRE_KERNEL_MODULE += CONFIG_MT7601U:drivers/net/wireless/mediatek/mt7601u:mt7601u
REQUIRE_KERNEL_MODULE += CONFIG_RT2X00_LIB_USB:drivers/net/wireless/rt2x00:rt2x00lib
REQUIRE_KERNEL_MODULE += CONFIG_RT2X00_LIB_USB:drivers/net/wireless/rt2x00:rt2x00usb
REQUIRE_KERNEL_MODULE += CONFIG_RT2500USB:drivers/net/wireless/rt2x00:rt2500usb
REQUIRE_KERNEL_MODULE += CONFIG_RT73USB:drivers/net/wireless/rt2x00:rt73usb
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/rt2x00:rt2800lib
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/rt2x00:rt2800usb
REQUIRE_KERNEL_MODULE += CONFIG_USB_ZD1201:drivers/net/wireless:zd1201

MAINTAINER = th0ma7
DESCRIPTION = "Includes Atmel, MediaTek, Ralink, ZyDAS USB WIFI adapters as well as out-of-tree Realtek RTL8812AU/21AU and RTL8814AU"

RELOAD_UI = no
STARTABLE = yes
DISPLAY_NAME = SynoKernel Wireless drivers

WIZARDS_DIR = src/wizard/

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

SSS_SCRIPT        = src/dsm-control.sh
SERVICE_SETUP     = src/service-setup.sh
STRIP_TARGET      = nop
POST_STRIP_TARGET = wifi_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: wifi_extra_install
wifi_extra_install:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/$(SPK_NAME).cfg $(STAGING_DIR)/etc/$(SPK_NAME).cfg

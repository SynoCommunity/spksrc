SPK_NAME = synokernel-wifi
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synokernel-wifi.png

DEPENDS  = cross/linux-firmware-wifi
DEPENDS += driver/rtl88x2bu
DEPENDS += driver/rtl8821cu
DEPENDS += driver/rtl8821au
DEPENDS += driver/rtl8812au
DEPENDS += driver/rtl8814au
DEPENDS += driver/rtw88
DEPENDS += driver/wireless-regdb

REQUIRE_KERNEL ?= 1
# No USB WiFi driver of the kernel builds on 2.6.32 (88f6281, qoriq), nor rtl88x2bu
MIN_KERNEL_VERSION = 3.2
# SRM has a wireless stack of its own, cfg80211 loaded for the radios of the router
UNSUPPORTED_ARCHS = $(SRM_ARCHS)

MAINTAINER = th0ma7
DESCRIPTION = "Provides drivers of USB WiFi adapters for DSM6 and DSM7, with the wireless stack of the Linux kernel, cfg80211 and mac80211, that DSM7 no longer ships."
CHANGELOG = "1. Initial release"

STARTABLE = no
WIZARDS_DIR = src/wizard/
DISPLAY_NAME = SynoKernel WiFi drivers

HOMEPAGE = https://wireless.docs.kernel.org/
LICENSE  = GPLv2

# The wireless stack, which DSM 7 kernels are built without. Wireless extensions stay
# off: they add fields to struct net_device and struct net of the running kernel.
REQUIRE_KERNEL_OPTION  = CONFIG_WIRELESS=y
REQUIRE_KERNEL_OPTION += CONFIG_WLAN=y
REQUIRE_KERNEL_OPTION += CONFIG_CFG80211_WEXT=n
REQUIRE_KERNEL_OPTION += CONFIG_WIRELESS_EXT=n
REQUIRE_KERNEL_OPTION += CONFIG_WEXT_CORE=n
REQUIRE_KERNEL_OPTION += CONFIG_MAC80211_MESH=n
# The signature check of the regulatory database is built in: the database is
# read unsigned, an option offered with CERTIFICATION_ONUS only, as the
# internal database of older kernels
REQUIRE_KERNEL_OPTION += CONFIG_EXPERT=y
REQUIRE_KERNEL_OPTION += CONFIG_CFG80211_CERTIFICATION_ONUS=y
REQUIRE_KERNEL_OPTION += CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=n
# Kernels before 4.15 compile the regulatory rules in (driver/wireless-regdb)
REQUIRE_KERNEL_OPTION += CONFIG_CFG80211_INTERNAL_REGDB=y
REQUIRE_KERNEL_OPTION += CONFIG_SYSTEM_DATA_VERIFICATION=n
REQUIRE_KERNEL_OPTION += CONFIG_SYSTEM_TRUSTED_KEYRING=n
# LED triggers are built in, and missing from some kernels: carl9170 does without,
# ath9k_htc needs them
REQUIRE_KERNEL_OPTION += CONFIG_LEDS_TRIGGERS=n
REQUIRE_KERNEL_OPTION += CONFIG_CARL9170_LEDS=n
# The vendor menus of the drivers, as they are named on each kernel
REQUIRE_KERNEL_OPTION += CONFIG_WLAN_VENDOR_ATH=y
REQUIRE_KERNEL_OPTION += CONFIG_ATH_CARDS=m
REQUIRE_KERNEL_OPTION += CONFIG_ATH_COMMON=m
REQUIRE_KERNEL_OPTION += CONFIG_WLAN_VENDOR_RALINK=y
REQUIRE_KERNEL_OPTION += CONFIG_RT2X00=m
REQUIRE_KERNEL_OPTION += CONFIG_WLAN_VENDOR_MEDIATEK=y
REQUIRE_KERNEL_OPTION += CONFIG_WL_MEDIATEK=y
REQUIRE_KERNEL_OPTION += CONFIG_WLAN_VENDOR_REALTEK=y
REQUIRE_KERNEL_OPTION += CONFIG_RTL_CARDS=m

REQUIRE_KERNEL_MODULE  = CONFIG_CFG80211:net/wireless:cfg80211
REQUIRE_KERNEL_MODULE += CONFIG_MAC80211:net/mac80211:mac80211

# USB adapters of the kernel, each module with the option of the driver that
# selects it, listed once per directory the driver had over time
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/rt2x00:rt2x00lib
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/rt2x00:rt2x00usb
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/rt2x00:rt2800lib
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/rt2x00:rt2800usb
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/ralink/rt2x00:rt2x00lib
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/ralink/rt2x00:rt2x00usb
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/ralink/rt2x00:rt2800lib
REQUIRE_KERNEL_MODULE += CONFIG_RT2800USB:drivers/net/wireless/ralink/rt2x00:rt2800usb
REQUIRE_KERNEL_MODULE += CONFIG_ATH9K_HTC:drivers/net/wireless/ath:ath:CONFIG_LEDS_TRIGGERS
REQUIRE_KERNEL_MODULE += CONFIG_ATH9K_HTC:drivers/net/wireless/ath/ath9k:ath9k_hw:CONFIG_LEDS_TRIGGERS
REQUIRE_KERNEL_MODULE += CONFIG_ATH9K_HTC:drivers/net/wireless/ath/ath9k:ath9k_common:CONFIG_LEDS_TRIGGERS
REQUIRE_KERNEL_MODULE += CONFIG_ATH9K_HTC:drivers/net/wireless/ath/ath9k:ath9k_htc:CONFIG_LEDS_TRIGGERS
REQUIRE_KERNEL_MODULE += CONFIG_CARL9170:drivers/net/wireless/ath:ath
REQUIRE_KERNEL_MODULE += CONFIG_CARL9170:drivers/net/wireless/ath/carl9170:carl9170
REQUIRE_KERNEL_MODULE += CONFIG_RTL8192CU:drivers/net/wireless/rtlwifi:rtlwifi
REQUIRE_KERNEL_MODULE += CONFIG_RTL8192CU:drivers/net/wireless/rtlwifi/rtl8192c:rtl8192c-common
REQUIRE_KERNEL_MODULE += CONFIG_RTL8192CU:drivers/net/wireless/rtlwifi/rtl8192cu:rtl8192cu
REQUIRE_KERNEL_MODULE += CONFIG_RTL8192CU:drivers/net/wireless/realtek/rtlwifi:rtlwifi
REQUIRE_KERNEL_MODULE += CONFIG_RTL8192CU:drivers/net/wireless/realtek/rtlwifi/rtl8192c:rtl8192c-common
REQUIRE_KERNEL_MODULE += CONFIG_RTL8192CU:drivers/net/wireless/realtek/rtlwifi/rtl8192cu:rtl8192cu
# The USB part of rtlwifi, in rtlwifi.ko on older kernels
REQUIRE_KERNEL_MODULE += CONFIG_RTLWIFI_USB:drivers/net/wireless/rtlwifi:rtl_usb
REQUIRE_KERNEL_MODULE += CONFIG_RTLWIFI_USB:drivers/net/wireless/realtek/rtlwifi:rtl_usb
REQUIRE_KERNEL_MODULE += CONFIG_RTL8XXXU:drivers/net/wireless/realtek/rtl8xxxu:rtl8xxxu
REQUIRE_KERNEL_MODULE += CONFIG_MT7601U:drivers/net/wireless/mediatek/mt7601u:mt7601u
REQUIRE_KERNEL_MODULE += CONFIG_MT76x0U:drivers/net/wireless/mediatek/mt76:mt76
REQUIRE_KERNEL_MODULE += CONFIG_MT76x0U:drivers/net/wireless/mediatek/mt76:mt76-usb
REQUIRE_KERNEL_MODULE += CONFIG_MT76x0U:drivers/net/wireless/mediatek/mt76:mt76x02-lib
REQUIRE_KERNEL_MODULE += CONFIG_MT76x0U:drivers/net/wireless/mediatek/mt76:mt76x02-usb
REQUIRE_KERNEL_MODULE += CONFIG_MT76x0U:drivers/net/wireless/mediatek/mt76/mt76x0:mt76x0-common
REQUIRE_KERNEL_MODULE += CONFIG_MT76x0U:drivers/net/wireless/mediatek/mt76/mt76x0:mt76x0u
REQUIRE_KERNEL_MODULE += CONFIG_MT76x2U:drivers/net/wireless/mediatek/mt76:mt76
REQUIRE_KERNEL_MODULE += CONFIG_MT76x2U:drivers/net/wireless/mediatek/mt76:mt76-usb
REQUIRE_KERNEL_MODULE += CONFIG_MT76x2U:drivers/net/wireless/mediatek/mt76:mt76x02-lib
REQUIRE_KERNEL_MODULE += CONFIG_MT76x2U:drivers/net/wireless/mediatek/mt76:mt76x02-usb
REQUIRE_KERNEL_MODULE += CONFIG_MT76x2U:drivers/net/wireless/mediatek/mt76/mt76x2:mt76x2-common
REQUIRE_KERNEL_MODULE += CONFIG_MT76x2U:drivers/net/wireless/mediatek/mt76/mt76x2:mt76x2u

# The profiles of the WiFi adapters come with synocli-kernel 2.1, and the
# tools to connect with synocli-wifi-tools
SPK_DEPENDS = "synocli-kernel>=2.1:synocli-wifi-tools>=1.0-1"

include ../../mk/spksrc.spk.mk

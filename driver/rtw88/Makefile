PKG_NAME = rtw88
PKG_VERS = 20261024
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/lwfinger/rtw88
PKG_GIT_HASH = f1dd7c3a5b87478ab23c3dbb1f8f0d6b82f3f71c
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/lwfinger/rtw88
COMMENT  = rtw88, the mac80211 driver of Realtek 802.11ac chips in Linux, kept building out of tree for older kernels.
LICENSE  = GPLv2

# The kernels it supports
DRIVER_KERNEL_MIN = 5.4

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtw88_compile
INSTALL_TARGET   = rtw88_install

# The core, and the USB adapters with their chip modules
RTW88_MODULES  = rtw_core rtw_usb
RTW88_MODULES += rtw_8822b rtw_8822bu rtw_8822c rtw_8822cu rtw_8821c rtw_8821cu
RTW88_MODULES += rtw_8723x rtw_8723d rtw_8723du
RTW88_MODULES += rtw_88xxa rtw_8812a rtw_8812au rtw_8821a rtw_8821au rtw_8814a rtw_8814au

include ../../mk/spksrc.driver.mk

.PHONY: rtw88_compile
rtw88_compile:
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtw88_install
rtw88_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless/rtw88
	cd $(WORK_DIR)/$(PKG_DIR) && install -m 644 $(addsuffix .ko,$(RTW88_MODULES)) $(DRIVER_MODULE_DIR)/drivers/net/wireless/rtw88/

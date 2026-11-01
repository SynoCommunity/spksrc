PKG_NAME = linux-firmware-wifi
PKG_VERS = 20261019
PKG_EXT = tar.xz
PKG_DIST_NAME = linux-firmware-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://cdn.kernel.org/pub/linux/kernel/firmware
PKG_DIR = linux-firmware-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
COMMENT  = Firmware of the USB WiFi adapters of synokernel-wifi, from linux-firmware.
LICENSE  = Each firmware is licensed under its own terms, see WHENCE

# Only the firmware of the drivers built, out of a 650 MB archive
FIRMWARE  = rt2870.bin
FIRMWARE += rt3071.bin
FIRMWARE += carl9170-1.fw
FIRMWARE += htc_7010.fw
FIRMWARE += htc_9271.fw
FIRMWARE += ath9k_htc/htc_7010-1.4.0.fw
FIRMWARE += ath9k_htc/htc_9271-1.4.0.fw
FIRMWARE += mediatek/mt7601u.bin
FIRMWARE += mediatek/mt7610u.bin
FIRMWARE += mediatek/mt7662u.bin
FIRMWARE += mediatek/mt7662u_rom_patch.bin
FIRMWARE += rtlwifi/rtl8192cufw.bin
FIRMWARE += rtlwifi/rtl8192cufw_A.bin
FIRMWARE += rtlwifi/rtl8192cufw_B.bin
FIRMWARE += rtlwifi/rtl8192cufw_TMSC.bin
FIRMWARE += rtlwifi/rtl8188eufw.bin
FIRMWARE += rtlwifi/rtl8192eu_nic.bin
FIRMWARE += rtlwifi/rtl8192fufw.bin
FIRMWARE += rtlwifi/rtl8710bufw_SMIC.bin
FIRMWARE += rtlwifi/rtl8710bufw_UMC.bin
FIRMWARE += rtlwifi/rtl8723aufw_A.bin
FIRMWARE += rtlwifi/rtl8723aufw_B.bin
FIRMWARE += rtlwifi/rtl8723aufw_B_NoBT.bin
FIRMWARE += rtlwifi/rtl8723bu_nic.bin
FIRMWARE += WHENCE

EXTRACT_CMD = tar -xJf $(DIST_FILE) -C $(EXTRACT_PATH) $(addprefix $(PKG_DIR)/,$(FIRMWARE))

CONFIGURE_TARGET = nop
COMPILE_TARGET   = nop
INSTALL_TARGET   = linux-firmware-wifi_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: linux-firmware-wifi_install
linux-firmware-wifi_install:
	cd $(WORK_DIR)/$(PKG_DIR) && for f in $(filter-out WHENCE,$(FIRMWARE)); do install -D -m 644 $$f $(STAGING_INSTALL_PREFIX)/lib/firmware/$$f ; done
	@# The names the drivers of older kernels ask for, as linux-firmware links them
	ln -sf rt2870.bin $(STAGING_INSTALL_PREFIX)/lib/firmware/rt3070.bin
	ln -sf mediatek/mt7601u.bin $(STAGING_INSTALL_PREFIX)/lib/firmware/mt7601u.bin
	install -D -m 644 $(WORK_DIR)/$(PKG_DIR)/WHENCE $(STAGING_INSTALL_PREFIX)/share/licenses/$(PKG_NAME)/WHENCE

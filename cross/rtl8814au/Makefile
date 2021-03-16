PKG_NAME = rtl8814au
PKG_VERS = 5.8.5.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aircrack-ng/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =
REQUIRE_KERNEL = 1

HOMEPAGE = https://github.com/aircrack-ng/rtl8814au
COMMENT  = Realtek RTL8814AU USB Software Package - Linux Driver
LICENSE  = GPLv2

CONFIGURE_TARGET = nop
COMPILE_TARGET = rtl8814au_compile
INSTALL_TARGET = rtl8814au_install

#UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

include ../../mk/spksrc.cross-cc.mk

.PHONY: rtl8814au_compile
rtl8814au_compile:
	$(RUN) ARCH=$(TC_ARCH) CROSS_COMPILE= KSRC=$(WORK_DIR)/linux make modules

.PHONY: rtl8814au_install
rtl8814au_install:
# Add "+" to EXTRAVERSION for kernels version >= 4.x
ifeq ($(call version_ge, ${TC_KERNEL}, 4),1)
	$(RUN) mkdir -p $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)+/kernel/drivers/net/wireless/
	@install -p -m 644 $(WORK_DIR)/$(PKG_DIR)/8814au.ko $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)+/kernel/drivers/net/wireless/
else
	$(RUN) mkdir -p $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/
	@install -p -m 644 $(WORK_DIR)/$(PKG_DIR)/8814au.ko $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/
endif

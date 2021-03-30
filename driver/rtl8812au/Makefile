PKG_NAME = rtl8812au
PKG_VERS = 5.6.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aircrack-ng/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =
REQUIRE_KERNEL = 1

HOMEPAGE = https://github.com/aircrack-ng/rtl8812au
COMMENT  = Realtek RTL8812AU USB Software Package - Linux Driver
LICENSE  = GPLv2

CONFIGURE_TARGET = nop
COMPILE_TARGET = rtl8812au_compile
INSTALL_TARGET = rtl8812au_install

include ../../mk/spksrc.cross-cc.mk

PLIST_TRANSFORM = sed -e 's%@TC_KERNEL@%$(TC_KERNEL)%'

.PHONY: rtl8812au_compile
rtl8812au_compile:
	$(RUN) ARCH=$(TC_ARCH) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) KSRC=$(WORK_DIR)/linux make modules

.PHONY: rtl8812au_install
rtl8812au_install:
	$(RUN) mkdir -p $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/
	@install -p -m 644 $(WORK_DIR)/$(PKG_DIR)/88XXau.ko $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/
	$(RUN) $(STRIP) --strip-debug $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/88XXau.ko

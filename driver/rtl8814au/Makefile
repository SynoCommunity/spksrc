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

KO = 8814au.ko
KO_DIR = $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/realtek

include ../../mk/spksrc.cross-cc.mk

PLIST_TRANSFORM = sed -e 's%@TC_KERNEL@%$(TC_KERNEL)%'

.PHONY: rtl8814au_compile
rtl8814au_compile:
	$(RUN) ARCH=$(TC_ARCH) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) KSRC=$(WORK_DIR)/linux make modules

.PHONY: rtl8814au_install
rtl8814au_install:
	$(RUN) mkdir -p $(KO_DIR)
	@install -p -m 644 $(WORK_DIR)/$(PKG_DIR)/$(KO) $(KO_DIR)
	$(RUN) $(STRIP) --strip-debug $(KO_DIR)/$(KO)

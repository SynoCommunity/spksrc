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

include ../../mk/spksrc.cross-cc.mk

PLIST_TRANSFORM = sed -e 's%@TC_KERNEL@%$(TC_KERNEL)%'

.PHONY: rtl8814au_compile
rtl8814au_compile:
	$(RUN) ARCH=$(TC_ARCH) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) KSRC=$(WORK_DIR)/linux make modules

.PHONY: rtl8814au_install
rtl8814au_install:
	$(RUN) mkdir -p $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/
	@install -p -m 644 $(WORK_DIR)/$(PKG_DIR)/8814au.ko $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/
	$(RUN) $(STRIP) --strip-debug $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/drivers/net/wireless/8814au.ko

#################
# TODO:
#    1) faire pointer le Makefile vers les cross-compilers                          - DONE
#    2) faire patch pour desactiver -Wimplicit-fallthrough=0 (rtl8812au uniquement) - DONE
#    3) AJOUTER $(STRIP) --strip-debug                                              - DONE
#    4) corriger le tc_vars pour TC_KERNEL avec + pour simplifier le code           - DONE
#    5) corriger le spkclean vs REQUIRE_KERNEL                                      - *TODO*
#    5) Repenser l'approche pour TC_TYPE                                            - *TODO*
#################

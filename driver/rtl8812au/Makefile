PKG_NAME = rtl8812au
PKG_VERS = 20210820
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/morrownr/8812au-20210820
PKG_GIT_HASH = 4722250273e4316daf9d8688e9916ea94c36a5ff
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/morrownr/8812au-20210820
COMMENT  = Realtek driver of the RTL8812AU USB WiFi adapters, with the updates of the Linux community.
LICENSE  = GPLv2

# Kernels before 4.4 lack strscpy, among others
DRIVER_KERNEL_MIN = 4.4

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8812au_compile
INSTALL_TARGET   = rtl8812au_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8812au_compile
rtl8812au_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8812AU=m OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8812au_install
rtl8812au_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/8812au.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

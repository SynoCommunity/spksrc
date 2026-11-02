PKG_NAME = rtl8814au
PKG_VERS = 20260818
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/morrownr/8814au
PKG_GIT_HASH = 1840d7b23bf2350a3e9e22448a93c251d2fec73c
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/morrownr/8814au
COMMENT  = Realtek driver of the RTL8814AU USB WiFi adapters, with the updates of the Linux community.
LICENSE  = GPLv2

# Kernels before 4.4 lack strscpy, among others
DRIVER_KERNEL_MIN = 4.4

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8814au_compile
INSTALL_TARGET   = rtl8814au_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8814au_compile
rtl8814au_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8814AU=m OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8814au_install
rtl8814au_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/8814au.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

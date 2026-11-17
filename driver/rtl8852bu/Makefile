PKG_NAME = rtl8852bu
PKG_VERS = 20250826
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/morrownr/rtl8852bu-20250826
PKG_GIT_HASH = b6a299b4fe95cb6a37eec27a6c3b21cbaa6abfa8
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/morrownr/rtl8852bu-20250826
COMMENT  = Realtek driver of the RTL8832BU and RTL8852BU USB WiFi 6 adapters, with the updates of the Linux community.
LICENSE  = GPLv2

# The driver supports kernels 5.4 and newer
DRIVER_KERNEL_MIN = 5.4

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8852bu_compile
INSTALL_TARGET   = rtl8852bu_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8852bu_compile
rtl8852bu_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host,
	@# and KSRC, for the kernel version it reads
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8852BU=m KSRC=$(KERNEL_ROOT) OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8852bu_install
rtl8852bu_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/8852bu.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

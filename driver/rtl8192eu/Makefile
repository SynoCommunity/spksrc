PKG_NAME = rtl8192eu
PKG_VERS = 20260906
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/Mange/rtl8192eu-linux-driver
PKG_GIT_HASH = c629cc972a0d878c930d19c4a9309c27c1e61f92
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/Mange/rtl8192eu-linux-driver
COMMENT  = Realtek driver of the RTL8192EU USB WiFi adapters, for the kernels whose rtl8xxxu lacks them.
LICENSE  = GPLv2

DRIVER_KERNEL_MIN = 3.2

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8192eu_compile
INSTALL_TARGET   = rtl8192eu_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8192eu_compile
rtl8192eu_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8192EU=m OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8192eu_install
rtl8192eu_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/8192eu.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

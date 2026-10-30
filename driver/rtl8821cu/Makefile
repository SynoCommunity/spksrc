PKG_NAME = rtl8821cu
PKG_VERS = 20210916
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/morrownr/8821cu-20210916
PKG_GIT_HASH = bda65aac150d2cde0df9603206eec23a6f3b77c4
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/morrownr/8821cu-20210916
COMMENT  = Realtek driver of the RTL8811CU and RTL8821CU USB WiFi adapters, with the updates of the Linux community.
LICENSE  = GPLv2

DRIVER_KERNEL_MIN = 3.2

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8821cu_compile
INSTALL_TARGET   = rtl8821cu_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8821cu_compile
rtl8821cu_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8821cu_install
rtl8821cu_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/8821cu.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

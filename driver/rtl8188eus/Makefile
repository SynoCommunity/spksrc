PKG_NAME = rtl8188eus
PKG_VERS = 20250203
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/aircrack-ng/rtl8188eus
PKG_GIT_HASH = af3bf004458f76b7aec33e9ba552cd382ed1f5c3
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/aircrack-ng/rtl8188eus
COMMENT  = Realtek driver of the RTL8188EU and RTL8188EUS USB WiFi adapters, for the kernels whose rtl8xxxu lacks them.
LICENSE  = GPLv2

DRIVER_KERNEL_MIN = 3.2

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8188eus_compile
INSTALL_TARGET   = rtl8188eus_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8188eus_compile
rtl8188eus_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8188EU=m OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8188eus_install
rtl8188eus_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/8188eu.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

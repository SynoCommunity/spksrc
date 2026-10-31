PKG_NAME = rtl8821au
PKG_VERS = 20210708
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/morrownr/8821au-20210708
PKG_GIT_HASH = 1a819991f5b75e64dfcf922b96a6681f367cbba0
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/morrownr/8821au-20210708
COMMENT  = Realtek driver of the RTL8811AU and RTL8821AU USB WiFi adapters, with the updates of the Linux community.
LICENSE  = GPLv2

# Kernels before 4.4 lack strscpy, among others
DRIVER_KERNEL_MIN = 4.4

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8821au_compile
INSTALL_TARGET   = rtl8821au_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8821au_compile
rtl8821au_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8821AU=m OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8821au_install
rtl8821au_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/8821au.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

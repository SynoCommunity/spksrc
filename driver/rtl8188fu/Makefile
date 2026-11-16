PKG_NAME = rtl8188fu
PKG_VERS = 20261112
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/kelebek333/rtl8188fu
PKG_GIT_HASH = cefa9185df3e56d7208a8c147d0cf57b2440908f
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/kelebek333/rtl8188fu
COMMENT  = Realtek driver of the RTL8188FU USB WiFi adapters, for the kernels whose rtl8xxxu lacks them.
LICENSE  = GPLv2

DRIVER_KERNEL_MIN = 3.2

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl8188fu_compile
INSTALL_TARGET   = rtl8188fu_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl8188fu_compile
rtl8188fu_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8188FU=m OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl8188fu_install
rtl8188fu_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/rtl8188fu.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

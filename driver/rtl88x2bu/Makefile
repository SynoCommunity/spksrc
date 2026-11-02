PKG_NAME = rtl88x2bu
PKG_VERS = 20210702
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/morrownr/88x2bu-20210702
PKG_GIT_HASH = 418d71cc00cd18b4a671f8c49ecce9b19cbfd3c9
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/morrownr/88x2bu-20210702
COMMENT  = Realtek driver of the RTL8812BU and RTL8822BU USB WiFi adapters, with the updates of the Linux community.
LICENSE  = GPLv2

# Neither the radiotap nor the byte order code of the driver builds on 2.6.32
DRIVER_KERNEL_MIN = 3.2

CONFIGURE_TARGET = nop
COMPILE_TARGET   = rtl88x2bu_compile
INSTALL_TARGET   = rtl88x2bu_install

include ../../mk/spksrc.driver.mk

.PHONY: rtl88x2bu_compile
rtl88x2bu_compile:
	@# kbuild directly: the Makefile of the driver passes the ARCH of the build host
	$(RUN) MAKEFLAGS= LDFLAGS= $(MAKE) -C $(KERNEL_ROOT) M=$(WORK_DIR)/$(PKG_DIR) \
	  TopDIR=$(WORK_DIR)/$(PKG_DIR) CONFIG_RTL8822BU=m OBJECT_FILES_NON_STANDARD=y \
	  KBUILD_EXTRA_SYMBOLS=$(KERNEL_ROOT)/modules.symvers -j$(NCPUS) modules

.PHONY: rtl88x2bu_install
rtl88x2bu_install:
	install -d -m 755 $(DRIVER_MODULE_DIR)/drivers/net/wireless
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/88x2bu.ko $(DRIVER_MODULE_DIR)/drivers/net/wireless/

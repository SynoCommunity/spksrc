PKG_NAME = cdc-acm
PKG_DIR = $(PKG_NAME)

DOWNLOAD_TARGET = kernel

REQ_KERNEL = 1

HOMEPAGE = http://sourceforge.net/projects/dsgpl/
COMMENT  = cdc-acm driver
LICENSE  = GNU GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = cdc-acm_compile
INSTALL_TARGET = cdc-acm_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: cdc-acm_compile
cdc-acm_compile:
	@mkdir -p $(WORK_DIR)/$(PKG_DIR)
	@echo "obj-m += cdc-acm.o" > $(WORK_DIR)/$(PKG_DIR)/Makefile
	@cp $(KERNEL_DIR)/drivers/usb/class/cdc-acm.c $(WORK_DIR)/$(PKG_DIR)/
	@cp $(KERNEL_DIR)/drivers/usb/class/cdc-acm.h $(WORK_DIR)/$(PKG_DIR)/
	CPPFLAGS="" CFLAGS="" LDFLAGS="" \
	make -C $(KERNEL_DIR) SUBDIRS=$(WORK_DIR)/$(PKG_DIR) modules

.PHONY: cdc-acm_install
cdc-acm_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/modules
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).ko $(STAGING_INSTALL_PREFIX)/modules/

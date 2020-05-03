PKG_NAME = ti_usb_3410_5052
PKG_DIR = $(PKG_NAME)

DOWNLOAD_TARGET = kernel

REQ_KERNEL = 1

HOMEPAGE = http://sourceforge.net/projects/dsgpl/
COMMENT  = ti_usb_3410_5052 USB to UART Bridge VCP Drivers
LICENSE  = GNU GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = ti_usb_3410_5052_compile
INSTALL_TARGET = ti_usb_3410_5052_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: ti_usb_3410_5052_compile
ti_usb_3410_5052_compile:
	@mkdir -p $(WORK_DIR)/$(PKG_DIR)
	@echo "obj-m += ti_usb_3410_5052.o" > $(WORK_DIR)/$(PKG_DIR)/Makefile
	@cp $(KERNEL_DIR)/drivers/usb/serial/ti_usb_3410_5052.h $(WORK_DIR)/$(PKG_DIR)/
	@cp $(KERNEL_DIR)/drivers/usb/serial/ti_usb_3410_5052.c $(WORK_DIR)/$(PKG_DIR)/
	CPPFLAGS="" CFLAGS="" LDFLAGS="" \
	make -C $(KERNEL_DIR) SUBDIRS=$(WORK_DIR)/$(PKG_DIR) modules

.PHONY: ti_usb_3410_5052_install
ti_usb_3410_5052_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/modules
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).ko $(STAGING_INSTALL_PREFIX)/modules/

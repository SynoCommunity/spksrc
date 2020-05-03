PKG_NAME = ch341
PKG_DIR = $(PKG_NAME)

DOWNLOAD_TARGET = kernel

REQ_KERNEL = 1

HOMEPAGE = http://sourceforge.net/projects/dsgpl/
COMMENT  = CP210x USB to UART Bridge VCP Drivers
LICENSE  = GNU GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = ch341_compile
INSTALL_TARGET = ch341_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: ch341_compile
ch341_compile:
	@mkdir -p $(WORK_DIR)/$(PKG_DIR)
	@echo "obj-m += ch341.o" > $(WORK_DIR)/$(PKG_DIR)/Makefile
	@cp $(KERNEL_DIR)/drivers/usb/serial/ch341.c $(WORK_DIR)/$(PKG_DIR)/
	CPPFLAGS="" CFLAGS="" LDFLAGS="" \
	make -C $(KERNEL_DIR) SUBDIRS=$(WORK_DIR)/$(PKG_DIR) modules

.PHONY: ch341_install
ch341_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/modules
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).ko $(STAGING_INSTALL_PREFIX)/modules/

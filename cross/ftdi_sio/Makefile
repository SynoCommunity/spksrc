PKG_NAME = ftdi_sio
PKG_DIR = $(PKG_NAME)

DOWNLOAD_TARGET = kernel

REQ_KERNEL = 1

HOMEPAGE = http://sourceforge.net/projects/dsgpl/
COMMENT  = CP210x USB to UART Bridge VCP Drivers
LICENSE  = GNU GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = ftdi_sio_compile
INSTALL_TARGET = ftdi_sio_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: ftdi_sio_compile
ftdi_sio_compile:
	@mkdir -p $(WORK_DIR)/$(PKG_DIR)
	@echo "obj-m += ftdi_sio.o" > $(WORK_DIR)/$(PKG_DIR)/Makefile
	@cp $(KERNEL_DIR)/drivers/usb/serial/ftdi_sio.h $(WORK_DIR)/$(PKG_DIR)/
	@cp $(KERNEL_DIR)/drivers/usb/serial/ftdi_sio_ids.h $(WORK_DIR)/$(PKG_DIR)/
	@cp $(KERNEL_DIR)/drivers/usb/serial/ftdi_sio.c $(WORK_DIR)/$(PKG_DIR)/
	CPPFLAGS="" CFLAGS="" LDFLAGS="" \
	make -C $(KERNEL_DIR) SUBDIRS=$(WORK_DIR)/$(PKG_DIR) modules

.PHONY: ftdi_sio_install
ftdi_sio_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/modules
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).ko $(STAGING_INSTALL_PREFIX)/modules/

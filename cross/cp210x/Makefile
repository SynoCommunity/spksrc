PKG_NAME = cp210x
PKG_DIR = $(PKG_NAME)

DOWNLOAD_TARGET = kernel

REQ_KERNEL = 1

HOMEPAGE = http://sourceforge.net/projects/dsgpl/
COMMENT  = CP210x USB to UART Bridge VCP Drivers
LICENSE  = GNU GPL

CONFIGURE_TARGET = nope
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	@mkdir -p $(WORK_DIR)/$(PKG_DIR)
	@echo "obj-m += cp210x.o" > $(WORK_DIR)/$(PKG_DIR)/Makefile
	@cp $(KERNEL_DIR)/drivers/usb/serial/cp210x.c $(WORK_DIR)/$(PKG_DIR)/
	CPPFLAGS="" CFLAGS="" LDFLAGS="" \
	make -C $(KERNEL_DIR) SUBDIRS=$(WORK_DIR)/$(PKG_DIR) modules

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/modules
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).ko $(STAGING_INSTALL_PREFIX)/modules/

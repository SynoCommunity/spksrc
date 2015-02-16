PKG_NAME = cp210x
PKG_EXT = zip
PKG_DIST_SITE = http://www.silabs.com/Support%20Documents/Software
PKG_DIST_NAME = Linux_3.x.x_VCP_Driver_Source.zip
PKG_DIST_FILE = cpx210x.zip
PKG_DIR = cpx210x

REQ_KERNEL = 1

HOMEPAGE = http://www.silabs.com
COMMENT  = CP210x USB to UART Bridge VCP Drivers
LICENSE  = 

POST_EXTRACT_TARGET = myPostExtract
CONFIGURE_TARGET = nope
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostExtract
myPostExtract:
	@cd $(WORK_DIR) ; \
	mv Linux_3.x.x_VCP_Driver_Source $(PKG_DIR) ; \

.PHONY: myCompile
myCompile:
	cp $(KERNEL_DIR)/drivers/usb/serial/cp210x.c $(WORK_DIR)/$(PKG_DIR)/cp210x.c
	CPPFLAGS="" CFLAGS="" LDFLAGS="" \
	make -C $(KERNEL_DIR) SUBDIRS=$(WORK_DIR)/$(PKG_DIR) modules

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/modules
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).ko $(STAGING_INSTALL_PREFIX)/modules/

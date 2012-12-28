PKG_NAME = synogpl
PKG_VERS = 2636
PKG_ARCH = 6281
PKG_EXT = tbz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_VERS)branch
PKG_DIR = source/linux-2.6.32

DEPENDS = 

HOMEPAGE = http://www.synology.com/
COMMENT  = 
LICENSE  =

GNU_CONFIGURE = 0
CONFIGURE_ARGS = 

EXTRACT_TARGET = kernel_extract_target
CONFIGURE_TARGET = kernel_null_target
PRE_COMPILE_TARGET = kernel_precompile_target
COMPILE_TARGET = kernel_compile_target
INSTALL_TARGET = kernel_null_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: kernel_null_target kernel_extract_target kernel_compile_target kernel_precompile_target
kernel_extract_target:
	tar -xpf $(DIST_FILE) -C $(EXTRACT_PATH) $(PKG_DIR)
kernel_precompile_target:
	cp $(EXTRACT_PATH)/$(PKG_DIR)/synoconfigs/88f6281 $(EXTRACT_PATH)/$(PKG_DIR)/.config
	# Update the Makefile
	sed -i -r 's,^ARCH\t+.+,ARCH\t= arm,' $(WORK_DIR)/$(PKG_DIR)/Makefile
	sed -i -r 's,^CROSS_COMPILE\t+.+,CROSS_COMPILE\t= $(TC_PATH)$(TC_PREFIX),' $(WORK_DIR)/$(PKG_DIR)/Makefile
	ln -sf arm $(WORK_DIR)/$(PKG_DIR)/arch/88f6281
kernel_compile_target:
	cd $(WORK_DIR)/$(PKG_DIR) && $(MAKE) LDFLAGS="" modules
kernel_null_target:

PKG_NAME = ds.evansport
PKG_VERS = 6.1.dev
PKG_EXT = txz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/toolkit/DSM6.1
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 
REQUIRED_DSM = 6.1
UNSUPPORTED_ARCHS = $(ARM_ARCHES) $(PPC_ARCHES) $(x64_ARCHES)

HOMEPAGE = https://en.wikipedia.org/wiki/List_of_Intel_Atom_microprocessors
COMMENT  = Synoloy evansport toolkit including headers & libraries for GPU acceleration based on the PowerVR SGX545 from Imagination Technologies
LICENSE  = unknown

EXTRACT_TARGET = ds.evansport_custom_extract
CONFIGURE_TARGET = none
COMPILE_TARGET = none
INSTALL_TARGET = none

include ../../mk/spksrc.cross-cc.mk

.PHONY: ds.evansport_custom_extract

ds.evansport_custom_extract: 
	cd $(PKG_WORK_DIR) && env $(ENV) mkdir --parents $(INSTALL_DIR)/$(INSTALL_PREFIX)/include
	cd $(PKG_WORK_DIR) && env $(ENV) mkdir --parents $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
	cd $(PKG_WORK_DIR) && env $(ENV) tar -C $(INSTALL_DIR)/$(INSTALL_PREFIX)/include \
		--skip-old-files --strip-components=7 \
		-xvf $(DIST_FILE) \
		usr/local/i686-pc-linux-gnu/i686-pc-linux-gnu/sys-root/usr/include/intelce-utilities
	cd $(PKG_WORK_DIR) && env $(ENV) tar -C $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib \
		--skip-old-files --strip-components=7 \
		-xvf $(DIST_FILE) \
		usr/local/i686-pc-linux-gnu/i686-pc-linux-gnu/sys-root/usr/lib/intelce-utilities

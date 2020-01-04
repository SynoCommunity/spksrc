PKG_NAME = ds.evansport
PKG_VERS = 6.1.dev
PKG_EXT = txz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/toolkit/DSM6.1
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
TC_WORK_DIR = $(WORK_DIR)/../../../toolchains/$(TC)/work

DEPENDS = 
REQUIRED_DSM = 6.1
UNSUPPORTED_ARCHS = $(ARM_ARCHES) $(PPC_ARCHES) $(x64_ARCHES)

HOMEPAGE = https://en.wikipedia.org/wiki/List_of_Intel_Atom_microprocessors
COMMENT  = Synoloy evansport toolkit including headers & libraries for GPU acceleration based on the PowerVR SGX545 from Imagination Technologies
LICENSE  = unknown

EXTRACT_TARGET = ds.evansport_custom_extract
CONFIGURE_TARGET = ds.evansport_custom_configure
COMPILE_TARGET = ds.evansport_custom_compile
INSTALL_TARGET = ds.evansport_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: ds.evansport_custom_extract

ds.evansport_custom_extract: 
	cd $(PKG_WORK_DIR) && env $(ENV) tar -C $(TC_WORK_DIR) --skip-old-files --strip-components=2 -xvf $(DIST_FILE) usr/local/i686-pc-linux-gnu/i686-pc-linux-gnu

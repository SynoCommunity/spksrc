PKG_NAME = ocl-icd
PKG_VERS = 2.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OCL-dev/ocl-icd/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/OCL-dev/ocl-icd
COMMENT = Open Source alternative to vendor specific OpenCL ICD loaders.
LICENSE = BSD 2-Clause "Simplified" License

# [Khronos-OpenCL-Headers]
BUILD_DEPENDS += cross/Khronos-OpenCL-Headers

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = ocl-icd_pre_configure
CONFIGURE_ARGS  = --enable-custom-vendordir=$(INSTALL_PREFIX)/etc/OpenCL/vendors
CONFIGURE_ARGS += --enable-custom-layerdir=$(INSTALL_PREFIX)/etc/OpenCL/layers

include ../../mk/spksrc.cross-cc.mk

.PHONY: ocl-icd_pre_configure
ocl-icd_pre_configure:
	$(RUN) autoreconf -fiv

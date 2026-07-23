PKG_NAME = libjxl
PKG_VERS = 0.11.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libjxl/libjxl/archive/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5

DEPENDS = cross/libpng cross/brotli cross/lcms2 cross/openexr cross/highway cross/sjpeg-source

HOMEPAGE = https://jpeg.org/jpegxl/
COMMENT  = JPEG XL image format reference implementation.
LICENSE  = 3-Clause BSD

PRE_CONFIGURE_TARGET = libjxl_pre_configure

CONFIGURE_ARGS += -DCMAKE_EXPORT_COMPILE_COMMANDS=OFF
CONFIGURE_ARGS += -DBUILD_TESTING=OFF
CONFIGURE_ARGS += -DJPEGXL_ENABLE_TOOLS=FALSE
CONFIGURE_ARGS += -DJPEGXL_ENABLE_SKCMS=FALSE
CONFIGURE_ARGS += -DJPEGXL_ENABLE_DOXYGEN=FALSE
CONFIGURE_ARGS += -DJPEGXL_ENABLE_MANPAGES=FALSE
CONFIGURE_ARGS += -DJPEGXL_ENABLE_BENCHMARK=FALSE
CONFIGURE_ARGS += -DJPEGXL_ENABLE_EXAMPLES=FALSE

include ../../mk/spksrc.cross-cmake.mk

.PHONY: libjxl_pre_configure
# libjxl requires sjpeg as submodule in third_party folder (doesn't search for, doesn't use cross/sjpeg):
libjxl_pre_configure:
	@$(MSG) "Link sjpeg source into third_party folder"
	@rm -rf $(WORK_DIR)/$(PKG_DIR)/third_party/sjpeg
	@ln -sf $(WORK_DIR)/sjpeg-source $(WORK_DIR)/$(PKG_DIR)/third_party/sjpeg

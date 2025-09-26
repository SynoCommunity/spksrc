PKG_NAME = libjxl
PKG_VERS = 0.7.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libjxl/libjxl/archive/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Minimum GCC version required is 7, please update.
# initial version on Dec 27, 2019 requires gcc >= 6
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

DEPENDS = cross/libpng cross/brotli cross/lcms2 cross/openexr cross/highway cross/sjpeg-source

HOMEPAGE = https://jpeg.org/jpegxl/
COMMENT  = JPEG XL image format reference implementation.
LICENSE  = 3-Clause BSD

PRE_CONFIGURE_TARGET = libjxl_pre_configure

CMAKE_ARGS += -DCMAKE_EXPORT_COMPILE_COMMANDS=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF
CMAKE_ARGS += -DJPEGXL_ENABLE_TOOLS=FALSE
CMAKE_ARGS += -DJPEGXL_ENABLE_SKCMS=FALSE
CMAKE_ARGS += -DJPEGXL_ENABLE_DOXYGEN=FALSE
CMAKE_ARGS += -DJPEGXL_ENABLE_MANPAGES=FALSE
CMAKE_ARGS += -DJPEGXL_ENABLE_BENCHMARK=FALSE
CMAKE_ARGS += -DJPEGXL_ENABLE_EXAMPLES=FALSE

include ../../mk/spksrc.cross-cmake.mk

.PHONY: libjxl_pre_configure
# libjxl requires sjpeg as submodule in third_party folder (doesn't search for, doesn't use cross/sjpeg):
libjxl_pre_configure:
	@$(MSG) "Link sjpeg source into third_party folder"
	@rm -rf $(WORK_DIR)/$(PKG_DIR)/third_party/sjpeg
	@ln -sf $(WORK_DIR)/sjpeg-source $(WORK_DIR)/$(PKG_DIR)/third_party/sjpeg

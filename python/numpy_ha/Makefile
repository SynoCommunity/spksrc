PKG_NAME = numpy_ha
WHEEL_NAME = numpy
PKG_VERS = 2.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(WHEEL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/numpy
PKG_DIR = $(WHEEL_NAME)-$(PKG_VERS)

DEPENDS  = cross/openblas
CONFIGURE_ARGS += -Dblas=OpenBLAS

POST_CONFIGURE_TARGET = numpy_post_configure
CONFIGURE_ARGS += --cross-file=$(WORK_DIR)/$(PKG_DIR)/numpy.meson

# Requires devel for:
#   numpy/_core/lib/libnpymath.a
#   numpy/random/lib/libnpyrandom.a
INSTALL_ARGS += --tags=runtime,python-runtime,devel

HOMEPAGE = https://numpy.org/
COMMENT  = NumPy is the fundamental package for scientific computing with Python.
LICENSE  = NumPy Developers

# Requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

include ../../mk/spksrc.common.mk

# numpy badly detects CPU on x86_64
# CPU flags below are "apollolake" compatible
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -Dcpu-baseline="sse2,ssse3,sse41,sse42"
CONFIGURE_ARGS += -Dcpu-dispatch="popcnt"
endif

include ../../mk/spksrc.python-wheel-meson.mk

.PHONY: numpy_post_configure

numpy_post_configure:
	@echo "[properties]" > $(WORK_DIR)/$(PKG_DIR)/numpy.meson
	@echo "needs_exe_wrapper = false" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson
	@echo "longdouble_format = 'IEEE_DOUBLE_LE'" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson

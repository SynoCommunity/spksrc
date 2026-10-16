PKG_NAME = numpy_$(PKG_VERS)
PKG_REAL_NAME = numpy
PKG_VERS = 2.5.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/numpy
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

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

# Requires gcc>=9.3 to build sucesfully
# Using patch to allow DSM-7.1 gcc-8.5 compatibility
REQUIRED_MIN_DSM = 7.1
REQUIRED_MIN_SRM = 1.3

include ../../mk/spksrc.common.mk

# numpy badly detects CPU on x86_64
# CPU flags below are "apollolake" compatible
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -Dcpu-baseline="X86_V2"
CONFIGURE_ARGS += -Dcpu-dispatch=none
endif

include ../../mk/spksrc.python-wheel-meson.mk

.PHONY: numpy_post_configure

numpy_post_configure:
	@echo "[properties]" > $(WORK_DIR)/$(PKG_DIR)/numpy.meson
	@echo "needs_exe_wrapper = false" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson
# long double representation per target arch (values match numpy's own meson
# detection patterns; keep in sync with _LDOUBLE_FORMAT_* in
# mk/spksrc.toolchain/tc_vars.mk): x86_64/i686 80-bit extended, AArch64
# 128-bit quad, 32-bit ARM and e500/SPE long double is 64-bit double.
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
	@echo "longdouble_format = 'IEEE_DOUBLE_BE'" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
	@echo "longdouble_format = 'IEEE_QUAD_LE'" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson
else ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
	@echo "longdouble_format = 'IEEE_DOUBLE_LE'" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
	@echo "longdouble_format = 'INTEL_EXTENDED_12_BYTES_LE'" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson
else ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
	@echo "longdouble_format = 'INTEL_EXTENDED_16_BYTES_LE'" >> $(WORK_DIR)/$(PKG_DIR)/numpy.meson
endif

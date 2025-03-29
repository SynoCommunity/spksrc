PKG_NAME = scipy
# Version >= 1.14.x requires gcc>=9.1 -> DSM-7.2+
# Or using patch to enforce lower minimal gcc-8.5
PKG_VERS = 1.15.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/s/scipy
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://scipy.org/
COMMENT  = SciPy provides algorithms for optimization, integration, interpolation, eigenvalue problems, algebraic equations, differential equations, statistics and many other classes of problems.
LICENSE  = 3-Clause BSD license

# Documentation:  https://docs.scipy.org/doc/scipy/building/cross_compilation.html

# Requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

DEPENDS  = python/numpy
DEPENDS += cross/openblas
CONFIGURE_ARGS  = --cross-file=$(WORK_DIR)/$(PKG_DIR)/scipy.meson

POST_CONFIGURE_TARGET = scipy_post_configure

include ../../mk/spksrc.python-wheel-meson.mk

.PHONY: scipy_post_configure

scipy_post_configure:
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@echo "[properties]" > $(WORK_DIR)/$(PKG_DIR)/scipy.meson
	@echo "numpy-include-dir = '$(CROSSENV_PATH)/cross/$(PYTHON_LIB_DIR)/site-packages/numpy/_core/include'" >>  $(WORK_DIR)/$(PKG_DIR)/scipy.meson
	@echo "pythran-include-dir = '$(CROSSENV_PATH)/build/$(PYTHON_LIB_DIR)/site-packages/pythran'" >>  $(WORK_DIR)/$(PKG_DIR)/scipy.meson
	@echo "build-python-path = '$(CROSSENV_PATH)/bin/build-python'" >>  $(WORK_DIR)/$(PKG_DIR)/scipy.meson
	@echo "build-python-version = '$(PYTHON_VERSION)'" >>  $(WORK_DIR)/$(PKG_DIR)/scipy.meson
	@echo "host-python-path = '$(CROSSENV_PATH)/bin/cross-python'" >>  $(WORK_DIR)/$(PKG_DIR)/scipy.meson
	@echo "host-python-version = '$(PYTHON_VERSION)'" >>  $(WORK_DIR)/$(PKG_DIR)/scipy.meson

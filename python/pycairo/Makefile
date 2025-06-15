PKG_NAME = pycairo
PKG_VERS = 1.28.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/pycairo
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/cairo

HOMEPAGE = https://pycairo.readthedocs.io/en/latest/
COMMENT  = Pycairo is a Python module providing bindings for the cairo graphics library.
LICENSE  = LGPL-2.1-only OR MPL-1.1

CONFIGURE_ARGS = --cross-file=$(WORK_DIR)/$(PKG_DIR)/pycairo.meson

POST_CONFIGURE_TARGET = pycairo_post_configure

include ../../mk/spksrc.python-wheel-meson.mk

.PHONY: pycairo_post_configure

pycairo_post_configure:
	@echo "[properties]" > $(WORK_DIR)/$(PKG_DIR)/pycairo.meson
	@echo "needs_exe_wrapper = false" >> $(WORK_DIR)/$(PKG_DIR)/pycairo.meson

PKG_NAME = dbus-python
PKG_VERS = 1.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/d/dbus-python
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/dbus cross/glib

HOMEPAGE = https://gitlab.freedesktop.org/dbus/dbus-python/
COMMENT  = Python bindings for D-Bus
LICENSE  = MIT License (Expat (MIT/X11))

CONFIGURE_ARGS  = --cross-file=$(WORK_DIR)/$(PKG_DIR)/dbus-python.meson

POST_CONFIGURE_TARGET = dbus-python_post_configure

include ../../mk/spksrc.python-wheel-meson.mk

.PHONY: dbus-python_post_configure

dbus-python_post_configure:
	@echo "[properties]" > $(WORK_DIR)/$(PKG_DIR)/dbus-python.meson
	@echo "needs_exe_wrapper = false" >> $(WORK_DIR)/$(PKG_DIR)/dbus-python.meson

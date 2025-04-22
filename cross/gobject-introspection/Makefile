PKG_NAME = gobject-introspection
PKG_VERS = 1.78.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.gnome.org/GNOME/$(PKG_NAME)/-/archive/$(PKG_VERS)

# gobject-introspection depends on a row of other packages, either strictly, optionally or only for testing.
# The following installation instructions should over all cases for some common Distributions.
# 
# sudo apt install pkg-config python3-dev flex bison libglib2.0-dev \
#     libcairo2-dev libffi-dev python3-mako \
#     python3-markdown python3-distutils meson build-essential \
#     gtk-doc-tools

DEPENDS = cross/glib cross/libffi cross/python311 cross/cairo

# generate gi.meson before Meson runs
CONFIGURE_TARGET := gi_post_configure meson_configure_target

# supply Meson with your custom cross‑file
CONFIGURE_ARGS += --cross-file=$(WORK_DIR)/$(PKG_DIR)/gi.meson

HOMEPAGE = https://gi.readthedocs.io/
COMMENT  = GObject introspection is a middleware layer between C libraries (using GObject) and language bindings.
LICENSE  = LGPLv2+

include ../../mk/spksrc.cross-meson.mk

.PHONY: gi_post_configure

gi_post_configure:
	@echo "[properties]" > $(WORK_DIR)/$(PKG_DIR)/gi.meson
	@echo "needs_exe_wrapper = true" >> $(WORK_DIR)/$(PKG_DIR)/gi.meson

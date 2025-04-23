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

# 1) Generate cross-file, then configure Meson as usual
CONFIGURE_TARGET = gi_post_configure meson_configure_target

# 2) After configure but before Ninja build, patch the scanner
COMPILE_TARGET = patch_gir_wrapper ninja_compile_target

.PHONY: gi_post_configure patch_gir_wrapper

gi_post_configure:
	@echo "[properties]" > $(WORK_DIR)/$(PKG_DIR)/gi.meson
	@echo "add_rpath = true" >> $(WORK_DIR)/$(PKG_DIR)/gi.meson

patch_gir_wrapper:
	@echo "Patching g-ir-scanner to load staged GLib…" ; \
	SCRIPT="$(MESON_BUILD_DIR)/tools/g-ir-scanner" ; \
	[ -f $$SCRIPT ] || { echo "❌ wrapper not found at $$SCRIPT"; exit 1; } ; \
	sed -i '1a export LD_LIBRARY_PATH=$(STAGING_INSTALL_PREFIX)/lib:$$LD_LIBRARY_PATH' $$SCRIPT ; \
	chmod +x $$SCRIPT

DEPENDS = cross/glib cross/libffi cross/cairo

# only required for build in cross/gobject-introspection folder (not when using prebuilt spk/python311)
BUILD_DEPENDS = cross/python311

# supply Meson with your custom cross‑file
CONFIGURE_ARGS += --cross-file=$(WORK_DIR)/$(PKG_DIR)/gi.meson

HOMEPAGE = https://gi.readthedocs.io/
COMMENT  = GObject introspection is a middleware layer between C libraries (using GObject) and language bindings.
LICENSE  = LGPLv2+

include ../../mk/spksrc.cross-meson.mk

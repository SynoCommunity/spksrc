# Set default build directory
ifeq ($(strip $(MESON_BUILD_DIR)),)
MESON_BUILD_DIR = builddir
endif

# Set other build options
CONFIGURE_ARGS += -Dbuildtype=release

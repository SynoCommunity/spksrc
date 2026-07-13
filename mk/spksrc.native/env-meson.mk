###############################################################################
# spksrc.native/env-meson.mk
#
# Set default build directory
#
###############################################################################

# Declare the build system (mirrors the cross env-meson.mk) so the gnu-make
# COMPILE_ARGS / INSTALL_ARGS defaults are not applied to native meson builds.
DEFAULT_ENV ?= meson

ifeq ($(strip $(BUILD_DIR)),)
BUILD_DIR = builddir
endif

# Set other build options
CONFIGURE_ARGS += -Dbuildtype=release

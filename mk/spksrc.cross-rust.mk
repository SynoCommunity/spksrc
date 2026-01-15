# Build rust programs
#
# This makefile extends spksrc.cross-cc.mk with Rust-specific functionality
# 
# prerequisites:
# - module does not require kernel (REQUIRE_KERNEL)
# 
# remarks:
# - CONFIGURE_TARGET is not supported (used for rust target installation)
# - build and install is done in one step
# 

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

##### rust specific configurations
include ../../mk/spksrc.cross-rust-env.mk

# configure is used to install rust targets
CONFIGURE_TARGET = nop

ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = nop
endif

ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = rust_install_target
endif

# Set default RUST_SRC_DIR
ifeq ($(strip $(RUST_SRC_DIR)),)
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

# Set the cargo install parameters
CARGO_INSTALL_ARGS += --path $(RUST_SRC_DIR)
CARGO_INSTALL_ARGS += --root $(STAGING_INSTALL_PREFIX)

# Append additional install options if present
ifneq ($(strip $(CARGO_BUILD_ARGS)),)
CARGO_INSTALL_ARGS += $(CARGO_BUILD_ARGS)
endif

###

# Rust specific targets
.PHONY: rust_install_target

# Default build with rust and install with cargo
# The cargo call uses tc_vars.mk RUSTUP_TOOLCHAIN variable
# overriding definition using +stable or +$(RUSTUP_TOOLCHAIN)
# https://rust-lang.github.io/rustup/environment-variables.html 
rust_install_target:
	@echo "  ==> Cargo install rust package $(PKG_NAME) (rustc +$(TC_RUSTUP_TOOLCHAIN) -vV)"
	@$(RUN) rustc +$(TC_RUSTUP_TOOLCHAIN) -vV
	@$(RUN) echo cargo +$(TC_RUSTUP_TOOLCHAIN) install $(CARGO_INSTALL_ARGS) --target $(RUST_TARGET)
	$(RUN) cargo +$(TC_RUSTUP_TOOLCHAIN) install $(CARGO_INSTALL_ARGS) --target $(RUST_TARGET)

###

# Include base cross-cc makefile for common functionality
include ../../mk/spksrc.cross-cc.mk

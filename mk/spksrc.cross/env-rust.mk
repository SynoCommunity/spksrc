###############################################################################
# spksrc.cross/env-rust.mk
#
# rustc cross-compilation definitions
#
###############################################################################

ifeq ($(TC_RUSTC),)
TC_RUSTC = stable
endif

# When calling directly from toolchain/syno-<arch>-<version>
# ARCH variable is still unset thus using $(TC_ARCH) although
# in generic archs we must rely on $(TC_NANE)
ifneq ($(ARCH),noarch)
RUST_ARCH = $(or $(ARCH),$(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))
endif

# map archs to rust targets -- only as a fallback: a toolchain building rustc from
# source declares RUST_TARGET itself (single source of truth, no drift between the
# toolchain build and the package build that consumes it).
ifeq ($(strip $(RUST_TARGET)),)
ifeq ($(findstring $(RUST_ARCH), $(ARMv5_ARCHS)),$(RUST_ARCH))
RUST_TARGET = armv5te-unknown-linux-gnueabi
endif

ifeq ($(findstring $(RUST_ARCH), $(ARMv7_ARCHS)),$(RUST_ARCH))
RUST_TARGET = armv7-unknown-linux-gnueabihf
endif

ifeq ($(findstring $(RUST_ARCH), $(ARMv7L_ARCHS)),$(RUST_ARCH))
RUST_TARGET = armv7-unknown-linux-gnueabi
endif

ifeq ($(findstring $(RUST_ARCH), $(ARMv8_ARCHS)),$(RUST_ARCH))
RUST_TARGET = aarch64-unknown-linux-gnu
endif

ifeq ($(findstring $(RUST_ARCH), $(PPC_ARCHS)),$(RUST_ARCH))
RUST_TARGET = powerpc-unknown-linux-gnuspe
endif

ifeq ($(findstring $(RUST_ARCH), $(x64_ARCHS)),$(RUST_ARCH))
RUST_TARGET = x86_64-unknown-linux-gnu
endif

ifeq ($(findstring $(RUST_ARCH), $(i686_ARCHS)),$(RUST_ARCH))
RUST_TARGET = i686-unknown-linux-gnu
endif
endif

# By default use the default toolchain if unset
ifeq ($(TC_RUSTUP_TOOLCHAIN),)
TC_RUSTUP_TOOLCHAIN = $(TC_RUSTC)
endif

# RUST_TARGET as a CARGO_TARGET_<triple>_* env suffix: upper-case, - -> _.
RUST_TARGET_UENV = $(shell echo $(RUST_TARGET) | tr 'a-z-' 'A-Z_')

# Deterministic cargo output in the build logs
ENV += CARGO_TERM_COLOR=never
ENV += CARGO_TERM_PROGRESS_WHEN=never

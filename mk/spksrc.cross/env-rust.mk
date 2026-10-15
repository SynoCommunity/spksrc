###############################################################################
# spksrc.cross/env-rust.mk
#
# rustc cross-compilation definitions
#
###############################################################################

# Include guard: overlay-rustc.mk sources this early (to get RUST_TARGET from the arch
# map before deriving the synology triple); tc_vars.mk / cross-rust.mk include it again.
ifndef __ENV_RUST_MK__
__ENV_RUST_MK__ := 1

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
ifeq ($(call version_lt, $(TC_GCC), 5),1)
ifeq ($(TC_RUSTC),stable)
# Rust 1.98 breaks the build with gcc 4.8.3
TC_RUSTC = 1.97.1
endif
endif
endif

ifeq ($(findstring $(RUST_ARCH), $(ARMv8_ARCHS)),$(RUST_ARCH))
RUST_TARGET = aarch64-unknown-linux-gnu
ifeq ($(call version_lt, $(TC_GCC), 5),1)
ifeq ($(TC_RUSTC),stable)
# Rust 1.98 breaks the build with gcc 4.9.4
# see: https://github.com/rust-lang/rust/issues/161486
TC_RUSTC = 1.97.1
endif
endif
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

# And as a cc-rs CC_/CXX_/AR_<triple> suffix. RUST_TARGET is already lower case, so the
# underscores are the whole conversion -- no shell, and it is read three times.
RUST_TARGET_LENV = $(subst -,_,$(RUST_TARGET))

# The build machine's own rust triple, to compare RUST_TARGET against. Stated rather
# than asked: every Synology toolchain ships x86_64 host binaries, so a machine that can
# run one is x86_64, and rustc names itself the same there. x64 is the single arch whose
# target triple is this string, and that equality is what tc_vars.rust.mk tests before
# naming anything HOST_*.
RUST_BUILD_TRIPLE = x86_64-unknown-linux-gnu

# Deterministic cargo output in the build logs is stated by tc_rust_vars, which every
# cross package loads; this file is also read by contexts that build no package.

endif # __ENV_RUST_MK__

# Configuration for rust compiler
#

ifeq ($(RUSTUP_DEFAULT_TOOLCHAIN),)
RUSTUP_DEFAULT_TOOLCHAIN = stable
endif

# Set to 1 to force building from
# source Tier-3 toolchains (qoriq)
# ref: https://rustc-dev-guide.rust-lang.org/building/how-to-build-and-run.html
ifeq ($(RUST_BUILD_TOOLCHAIN),)
RUST_BUILD_TOOLCHAIN = 0
endif

# Versions available: https://releases.rs/docs/
ifeq ($(RUST_BUILD_VERSION),)
RUST_BUILD_VERSION = 1.82.0
endif

# Enforce using newer cmake when building Tier-3 toolchains
ifeq ($(RUST_BUILD_TOOLCHAIN),1)
DEPENDS += native/cmake
CMAKE_PATH = $(abspath $(WORK_DIR)/../../../native/cmake/work-native/install/usr/local/bin)
ifeq ($(findstring cmake,$(subst /,,$(subst :,,$(PATH)))),)
export PATH:=$(CMAKE_PATH):$(PATH)
endif
endif

# When calling directly from toolchain/syno-<arch>-<version>
# ARCH variable is still unset thus using $(TC_ARCH) although
# in generic archs we must rely on $(TC_NANE)
ifneq ($(ARCH),noarch)
RUST_ARCH = $(or $(ARCH),$(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))
endif

# When building toolchain Tier-3 arch support
#   While stage-2 is the truly current compiler, stage-1 suffice our needs
#   https://rustc-dev-guide.rust-lang.org/building/bootstrapping.html#stage-2-the-truly-current-compiler
RUSTUP_DEFAULT_TOOLCHAIN_STAGE = 2

# map archs to rust targets
ifeq ($(findstring $(RUST_ARCH), $(ARMv5_ARCHS)),$(RUST_ARCH))
RUSTUP_DEFAULT_TOOLCHAIN = 1.77.2
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
TC_RUSTUP_TOOLCHAIN = $(RUST_BUILD_VERSION)-$(RUST_TARGET)
endif
ifeq ($(findstring $(RUST_ARCH), $(x64_ARCHS)),$(RUST_ARCH))
RUST_TARGET = x86_64-unknown-linux-gnu
endif
ifeq ($(findstring $(RUST_ARCH), $(i686_ARCHS)),$(RUST_ARCH))
RUST_TARGET = i686-unknown-linux-gnu
endif

ifeq ($(RUST_TARGET),)
$(error Arch $(RUST_ARCH) not supported)
endif

# By default use the default toolchain if unset
ifeq ($(TC_RUSTUP_TOOLCHAIN),)
TC_RUSTUP_TOOLCHAIN = $(RUSTUP_DEFAULT_TOOLCHAIN)
endif

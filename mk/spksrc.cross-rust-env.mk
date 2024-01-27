# Configuration for rust compiler
#

# Add cargo for rust compiler to default PATH
ifneq ($(BASE_DISTRIB_DIR),)
# Enforce newer cmake when building tier-3 toolchains
CMAKE_PATH = $(abspath $(WORK_DIR)/../../../native/cmake/work-native/install/usr/local/bin)
export CARGO_HOME=$(BASE_DISTRIB_DIR)/cargo
export RUSTUP_HOME=$(BASE_DISTRIB_DIR)/rustup
export PATH:=$(abspath $(BASE_DISTRIB_DIR)/cargo/bin):$(CMAKE_PATH):$(PATH)
endif

ifeq ($(RUSTUP_DEFAULT_TOOLCHAIN),)
RUSTUP_DEFAULT_TOOLCHAIN = stable
endif

# When building toolchain Tier-3 arch support
#   While stage-2 is the truly current compiler, stage-1 suffice our needs
#   https://rustc-dev-guide.rust-lang.org/building/bootstrapping.html#stage-2-the-truly-current-compiler
RUSTUP_DEFAULT_TOOLCHAIN_STAGE = 2

# When calling directly from toolchain/syno-<arch>-<version>
# ARCH variable is still unset thus using $(or $(ARCH),$(TC_ARCH))

# map archs to rust targets
ifeq ($(findstring $(or $(ARCH),$(TC_ARCH)), $(ARMv5_ARCHS)),$(or $(ARCH),$(TC_ARCH)))
RUST_TARGET = armv5te-unknown-linux-gnueabi
endif
ifeq ($(findstring $(or $(ARCH),$(TC_ARCH)), $(ARMv7_ARCHS)),$(or $(ARCH),$(TC_ARCH)))
RUST_TARGET = armv7-unknown-linux-gnueabihf
endif
ifeq ($(findstring $(or $(ARCH),$(TC_ARCH)), $(ARMv7L_ARCHS)),$(or $(ARCH),$(TC_ARCH)))
RUST_TARGET = armv7-unknown-linux-gnueabi
endif
ifeq ($(findstring $(or $(ARCH),$(TC_ARCH)), $(ARMv8_ARCHS)),$(or $(ARCH),$(TC_ARCH)))
RUST_TARGET = aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(or $(ARCH),$(TC_ARCH)), $(PPC_ARCHS)),$(or $(ARCH),$(TC_ARCH)))
RUST_BUILD_TOOLCHAIN = 0
RUST_TARGET = powerpc-unknown-linux-gnuspe
TC_RUSTUP_TOOLCHAIN = stage$(RUSTUP_DEFAULT_TOOLCHAIN_STAGE)-$(RUST_TARGET)
endif
ifeq ($(findstring $(or $(ARCH),$(TC_ARCH)), $(x64_ARCHS)),$(or $(ARCH),$(TC_ARCH)))
RUST_TARGET = x86_64-unknown-linux-gnu
endif
ifeq ($(findstring $(or $(ARCH),$(TC_ARCH)), $(i686_ARCHS)),$(or $(ARCH),$(TC_ARCH)))
RUST_TARGET = i686-unknown-linux-gnu
endif

ifeq ($(RUST_TARGET),)
$(error Arch $(or $(ARCH),$(TC_ARCH)) not supported)
endif

# By default use the default toolchain if unset
ifeq ($(TC_RUSTUP_TOOLCHAIN),)
TC_RUSTUP_TOOLCHAIN = $(RUSTUP_DEFAULT_TOOLCHAIN)
endif

# Configuration for rust compiler
#

# Add cargo for rust compiler to default PATH
ifneq ($(BASE_DISTRIB_DIR),)
# Enforce newer cmake when building tier-3 toolchains
CMAKE_PATH = $(abspath $(WORK_DIR)/../../../native/cmake/work-native/install/usr/local/bin)
LLVM_PATH = $(abspath $(WORK_DIR)/../../../native/llvm-9.0/work-native/install/usr/local/bin)
export CARGO_HOME=$(BASE_DISTRIB_DIR)/cargo
export RUSTUP_HOME=$(BASE_DISTRIB_DIR)/rustup
export PATH:=$(abspath $(BASE_DISTRIB_DIR)/cargo/bin):$(CMAKE_PATH):$(LLVM_PATH):$(PATH)
endif

ifeq ($(RUSTUP_DEFAULT_TOOLCHAIN),)
RUSTUP_DEFAULT_TOOLCHAIN = stable
endif

# When building toolchain Tier-3 arch support
#   While stage-2 is the truly current compiler, stage-1 suffice our needs
#   https://rustc-dev-guide.rust-lang.org/building/bootstrapping.html#stage-2-the-truly-current-compiler
RUSTUP_DEFAULT_TOOLCHAIN_STAGE = 1

ifeq ($(TC_RUSTUP_TOOLCHAIN),)
TC_RUSTUP_TOOLCHAIN = $(RUSTUP_DEFAULT_TOOLCHAIN)
endif

RUST_TARGET =
# map archs to rust targets
ifeq ($(findstring $(ARCH), $(x64_ARCHS)),$(ARCH))
RUST_TARGET = x86_64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(i686_ARCHS)),$(ARCH))
RUST_TARGET = i686-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(ARMv5_ARCHS)),$(ARCH))
# may be not supported for cargo
RUST_TARGET = armv5te-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH), $(ARMv7_ARCHS)),$(ARCH))
RUST_TARGET = armv7-unknown-linux-gnueabihf
endif
ifeq ($(findstring $(ARCH), $(ARMv7L_ARCHS)),$(ARCH))
RUST_TARGET = armv7-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH), $(ARMv8_ARCHS)),$(ARCH))
RUST_TARGET = aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
RUST_TARGET = powerpc-unknown-linux-gnuspe
TC_RUSTUP_TOOLCHAIN = stage$(RUSTUP_DEFAULT_TOOLCHAIN_STAGE)-$(RUST_TARGET)
endif
ifeq ($(RUST_TARGET),)
$(error Arch $(ARCH) not supported)
endif

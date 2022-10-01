# Configuration for rust compiler
# 

RUST_TOOLCHAIN ?= stable

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
RUST_TARGET = powerpc-unknown-linux-gnu
endif
ifeq ($(RUST_TARGET),)
$(error Arch $(ARCH) not supported)
endif

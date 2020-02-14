PKG_NAME = ripgrep
PKG_VERS = 11.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

CONFIGURE_TARGET 	= nop
COMPILE_TARGET   	= nop
INSTALL_TARGET 	= ripgrep_install

# armv7 without hardfloat is not supported
UNSUPPORTED_ARCHS = hi3535
# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += powerpc ppc824x ppc853x ppc854x


include ../../mk/spksrc.cross-cc.mk


RUST_TRIPLE =

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
RUST_TRIPLE=x86_64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
RUST_TRIPLE=i686-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
# may be not supported for cargo
RUST_TRIPLE=armv5te-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
RUST_TRIPLE=armv7-unknown-linux-gnueabihf
endif
ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
RUST_TRIPLE=aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
RUST_TRIPLE=powerpc-unknown-linux-gnu
endif

ifeq ($(RUST_TRIPLE),)
$(error Arch $(ARCH) not supported)
endif

# Set linker environment variable
RUST_LINKER_ENV=CARGO_TARGET_$(shell echo $(RUST_TRIPLE) | tr - _ | tr a-z A-Z)_LINKER
CARGO_ENV=$(RUST_LINKER_ENV)=$(TC_PATH)$(TC_PREFIX)gcc

# Use distrib folder as cargo download cache
ENV = CARGO_HOME=/spksrc/distrib/cargo

# Set the cargo target
CARGO_TARGET=--target=$(RUST_TRIPLE)

ripgrep_install:
	@$(MSG) "Installing ripgrep"
	$(CARGO_ENV) cargo install $(CARGO_TARGET) \
		--path $(WORK_DIR)/$(PKG_DIR) --root $(STAGING_INSTALL_PREFIX)

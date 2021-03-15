PKG_NAME = ripgrep
PKG_VERS = 11.0.2
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 3de31f752729525d85a3d1575ac1978733b3f7e7
PKG_DIST_NAME = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)

CONFIGURE_TARGET=ripgrep_configure
COMPILE_TARGET=ripgrep_compile
INSTALL_TARGET=ripgrep_install

PKG_CARGO_DIR = $(WORK_DIR)/$(PKG_NAME)-git$(PKG_GIT_HASH)

ifneq ($(ARCH),)
ifeq ($(ARCH),x64)
RUST_TRIPLE=x86_64-unknown-linux-gnu
else ifeq ($(ARCH),armada38x)
RUST_TRIPLE=armv7-unknown-linux-gnueabihf
else ifeq ($(ARCH),aarch64)
RUST_TRIPLE=aarch64-unknown-linux-gnu
else
# $(error Arch $(ARCH) not yet supported)
endif
endif

# Set linker environment variable
RUST_LINKER_ENV=CARGO_TARGET_$(shell echo $(RUST_TRIPLE) | tr - _ | tr a-z A-Z)_LINKER
CARGO_ENV=$(RUST_LINKER_ENV)=$(TC_PATH)$(TC_PREFIX)gcc

# Set the cargo target
CARGO_TARGET=--target=$(RUST_TRIPLE)

include ../../mk/spksrc.cross-cc.mk

ripgrep_configure:
	@echo "No configuration for ripgrep."

ripgrep_compile:
	@echo "No compiling for ripgrep (done in install)"

ripgrep_install:
	@echo "Installing ripgrep"
	$(CARGO_ENV) cargo install $(CARGO_TARGET) \
		--path $(PKG_CARGO_DIR) --root $(STAGING_INSTALL_PREFIX)

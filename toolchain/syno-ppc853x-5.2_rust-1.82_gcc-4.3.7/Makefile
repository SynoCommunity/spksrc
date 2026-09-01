TC_ARCH = ppc853x
TC_VERS = 5.2
TC_GCC = 4.3.7

PKG_NAME = rust
PKG_VERS = 1.82.0
PKG_EXT = txz
PKG_REV ?= v8
EXTRACT_PATH = $(INSTALL_DIR)/$(INSTALL_PREFIX)

DEPENDS =

HOMEPAGE = https://www.rust-lang.org/
COMMENT = A language empowering everyone to build reliable and efficient software.
LICENSE = Apache-2.0, MIT licenses

INSTALL_TARGET = nop
POST_INSTALL_TARGET = rust-postinstall

# Shared toolchain id -- must match overlay-rustc.mk's _RUST_TC_ID.
RUST_TC_ID = $(PKG_VERS)-powerpc-synology-linux-gnuspe-$(TC_ARCH)-$(TC_VERS)-gcc$(TC_GCC)
PKG_DIST_NAME = $(PKG_NAME)-$(RUST_TC_ID)-$(PKG_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/rust/qoriq

include ../../mk/spksrc.native-install.mk

.PHONY: rust-postinstall
rust-postinstall:
	@$(MSG) "Rust toolchain $(RUST_TC_ID) staged in $(RUSTUP_HOME)/toolchains"
	@export PATH="$(CARGO_HOME)/bin:$${PATH}" ; \
	which rustup ; \
	rustup --version ; \
	rustup toolchain link $(RUST_TC_ID) $(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)) ; \
	rustup show

idc:
	@echo "$(RUST_TC_ID)"

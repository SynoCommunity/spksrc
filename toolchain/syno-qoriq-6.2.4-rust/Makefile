PKG_ARCH = qoriq
PKG_NAME = rust-$(PKG_ARCH)
PKG_VERS = 1.82.0
PKG_EXT = txz
PKG_DIST_TARGET = $(PKG_VERS)-powerpc-unknown-linux-gnuspe
PKG_DIST_NAME = $(PKG_DIST_TARGET).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/rust/qoriq
EXTRACT_PATH = $(INSTALL_DIR)/$(INSTALL_PREFIX)

DEPENDS = 

HOMEPAGE = https://www.rust-lang.org/
COMMENT = A language empowering everyone to build reliable and efficient software.
LICENSE  = Apache-2.0, MIT licenses

# extracted directly into install folder
INSTALL_TARGET = nop
POST_INSTALL_TARGET = rust-qoriq-postinstall

CARGO_PATH=$(abspath $(BASE_DISTRIB_DIR)/cargo/bin)
RUSTUP_HOME=$(abspath $(BASE_DISTRIB_DIR)/rustup)

include ../../mk/spksrc.native-install.mk

.PHONY: rust-qoriq-postinstall
rust-qoriq-postinstall:
	@$(MSG) "Rustup $(PKG_DIST_TARGET)"
	@export PATH="$(CARGO_PATH):$${PATH}" ; \
	export RUSTUP_HOME="$(RUSTUP_HOME)" ; \
	which rustup ; \
	rustup toolchain link $(PKG_DIST_TARGET) $(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)) ; \
	rustup show

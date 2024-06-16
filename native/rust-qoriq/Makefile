PKG_NAME = rust-qoriq
PKG_VERS = 1.77.0-nightly
PKG_EXT = txz
PKG_DIST_NAME = stage2_powerpc-unknown-linux-gnuspe.txz
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2Frust%2F1.77.0-nightly
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
	export PATH="$(CARGO_PATH):$${PATH}" ; \
	export RUSTUP_HOME="$(RUSTUP_HOME)" ; \
	which rustup ; \
	rustup toolchain link stage2-powerpc-unknown-linux-gnuspe $(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)) ; \
	rustup show

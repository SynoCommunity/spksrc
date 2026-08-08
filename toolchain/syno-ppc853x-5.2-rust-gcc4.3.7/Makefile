PKG_NAME = rust-ppc853x-gcc4.3.7
PKG_VERS = 1.82.0
PKG_EXT = txz
EXTRACT_PATH = $(INSTALL_DIR)/$(INSTALL_PREFIX)

# Fields of the shared toolchain id -- must match the toolchain's _RUST_TC_ID
# (mk/spksrc.toolchain/rustc.mk): <ver>-<target>-<arch>-<dsm>-gcc<gcc>. The published
# .txz adds a -<rev> suffix (bumped when a rebuilt archive is re-uploaded).
RUST_TARGET      = powerpc-unknown-linux-gnuspe
RUST_TC_ARCH     = ppc853x
RUST_TC_VERS     = 5.2
RUST_TC_GCC      = 4.3.7
# Archive revision from the native producer structure (single source, CLI-
# overridable): native/rustc-1.82/archive-rev.mk, keyed on RUST_TC_ARCH/VERS.
include ../../native/rustc-1.82/archive-rev.mk
RUST_TC_ID       = $(PKG_VERS)-$(subst -unknown-,-synology-,$(RUST_TARGET))-$(RUST_TC_ARCH)-$(RUST_TC_VERS)-gcc$(RUST_TC_GCC)

CARGO_PATH=$(BASEDIR)/distrib/cargo/bin
RUSTUP_HOME=$(BASEDIR)/distrib/rustup

PKG_DIST_NAME = rust-$(RUST_TC_ID)-$(RUST_ARCHIVE_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/rust/qoriq

DEPENDS =

HOMEPAGE = https://www.rust-lang.org/
COMMENT = A language empowering everyone to build reliable and efficient software.
LICENSE = Apache-2.0, MIT licenses

INSTALL_TARGET = nop
POST_INSTALL_TARGET = rust-postinstall

include ../../mk/spksrc.native-install.mk

.PHONY: rust-postinstall
rust-postinstall:
	@$(MSG) "Rust toolchain $(RUST_TC_ID) staged in $(RUSTUP_HOME)/toolchains"
	@export PATH="$(CARGO_PATH):$${PATH}" ; \
	export RUSTUP_HOME="$(RUSTUP_HOME)" ; \
	which rustup ; \
	rustup --version ; \
	rustup toolchain link $(RUST_TC_ID) $(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)) ; \
	rustup show

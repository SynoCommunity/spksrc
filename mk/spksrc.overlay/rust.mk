###############################################################################
# spksrc.overlay/rust.mk
#
# A rust toolchain, as native/rustc-<version> publishes it: the x.py stage2 tree for this
# arch's synology triple, built with the gcc the directory names (_gcc-<version>), linked
# into rustup under the id a package build asks for (spksrc.toolchain/overlay-rustc.mk).
###############################################################################

PKG_NAME = rust
PKG_EXT  = txz
PKG_DIST_NAME = $(PKG_NAME)-$(RUST_TC_ID)-$(PKG_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/rust/qoriq
EXTRACT_PATH  = $(INSTALL_DIR)/$(INSTALL_PREFIX)

HOMEPAGE = https://www.rust-lang.org/
COMMENT  = A language empowering everyone to build reliable and efficient software.
LICENSE  = Apache-2.0, MIT licenses

INSTALL_TARGET      = nop
POST_INSTALL_TARGET = rust-postinstall

# The toolchain id, which must match overlay-rustc.mk's _RUST_TC_ID: the triple is the
# same arch map a package build reads (env-rust.mk), vendor field "synology". The map
# needs the arch groups, hence included once the framework is.
OVERLAY_LATE_INCLUDES += ../../mk/spksrc.cross/env-rust.mk
RUST_TC_ID = $(PKG_VERS)-$(subst -unknown-,-synology-,$(RUST_TARGET))-$(TC_ARCH)-$(TC_VERS)-gcc$(OVERLAY_RUST_GCC)

.PHONY: rust-postinstall
rust-postinstall:
	@$(MSG) "Rust toolchain $(RUST_TC_ID) staged in $(RUSTUP_HOME)/toolchains"
	@export PATH="$(CARGO_HOME)/bin:$${PATH}" ; \
	which rustup ; \
	rustup --version ; \
	rustup toolchain link $(RUST_TC_ID) $(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)) ; \
	rustup show

.PHONY: idc
idc:
	@echo "$(RUST_TC_ID)"

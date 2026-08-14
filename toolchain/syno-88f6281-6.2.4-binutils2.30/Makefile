PKG_NAME = binutils-88f6281-6.2.4
PKG_VERS = 2.30
PKG_EXT  = txz

# The published .txz unpacks usr/local/{bin,...}; extract into the install dir so the
# tools land at work-native/install/usr/local/bin -- where overlay-binutils.mk points.
EXTRACT_PATH = $(INSTALL_DIR)

# Fields of the published artifact name (native/binutils-$(PKG_VERS) co-builds + uploads it).
BINUTILS_TARGET      = arm-marvell-linux-gnueabi
BINUTILS_TC_ARCH     = 88f6281
BINUTILS_TC_VERS     = 6.2.4
BINUTILS_ARCHIVE_REV ?= v1
PKG_DIST_NAME = binutils-$(PKG_VERS)-$(BINUTILS_TARGET)-$(BINUTILS_TC_ARCH)-$(BINUTILS_TC_VERS)-$(BINUTILS_ARCHIVE_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/pre-releases

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU binutils 2.30 overlay (as/ld) for 88f6281-6.2.4, co-built by native/binutils-2.30 and downloaded here for the custom-rustc link (RUST_LINK_VIA_BINUTILS, see PR #7353). Only the Rust link routes through it; the C toolchain keeps the stock vendor binutils.
LICENSE  = GPLv3

INSTALL_TARGET = nop
POST_INSTALL_TARGET = binutils-shim

include ../../mk/spksrc.native-install.mk

# Build the unprefixed as/ld shim gcc reaches via -B (symmetric with the rust consumer's
# rustup-link POST_INSTALL). overlay-binutils.mk points OVERLAY_BINUTILS_SHIM at $(WORK_DIR)/shim.
.PHONY: binutils-shim
binutils-shim:
	@mkdir -p $(WORK_DIR)/shim
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(BINUTILS_TARGET)-ld $(WORK_DIR)/shim/ld
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(BINUTILS_TARGET)-as $(WORK_DIR)/shim/as

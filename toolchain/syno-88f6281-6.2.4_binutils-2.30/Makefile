TC_ARCH = 88f6281
TC_VERS = 6.2.4
TC_TARGET = arm-marvell-linux-gnueabi
# Archive to fetch: this arch's own, or the real arch whose toolchain a meta shares.
PKG_DIST_ARCH = $(TC_ARCH)

PKG_NAME = binutils
PKG_VERS = 2.30
PKG_EXT  = txz
PKG_REV ?= v1
EXTRACT_PATH = $(INSTALL_DIR)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv3

INSTALL_TARGET = nop
POST_INSTALL_TARGET = binutils-shim

PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(TC_TARGET)-$(PKG_DIST_ARCH)-$(TC_VERS)-$(PKG_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/pre-releases

include ../../mk/spksrc.native-install.mk

# Build the unprefixed as/ld shim gcc reaches via -B (symmetric with the rust consumer's
# rustup-link POST_INSTALL). overlay-binutils.mk points OVERLAY_BINUTILS_SHIM at $(WORK_DIR)/shim.
.PHONY: binutils-shim
binutils-shim:
	@mkdir -p $(WORK_DIR)/shim
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(TC_TARGET)-ld $(WORK_DIR)/shim/ld
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(TC_TARGET)-as $(WORK_DIR)/shim/as

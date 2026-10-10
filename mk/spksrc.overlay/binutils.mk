###############################################################################
# spksrc.overlay/binutils.mk
#
# The binutils overlay, as native/binutils-<version> publishes it: <target>-{as,ld,...}
# under usr/local/bin, plus the unprefixed as/ld shim a compile reaches through -B
# (OVERLAY_BINUTILS_SHIM, spksrc.toolchain/overlay-binutils.mk).
###############################################################################

PKG_NAME = binutils
PKG_EXT  = txz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(TC_TARGET)-$(OVERLAY_DIST_ARCH)-$(TC_VERS)-$(PKG_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2Fdsm$(TC_VERS)
EXTRACT_PATH  = $(INSTALL_DIR)

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv3

INSTALL_TARGET      = nop
POST_INSTALL_TARGET = binutils-shim

.PHONY: binutils-shim
binutils-shim:
	@mkdir -p $(WORK_DIR)/shim
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(TC_TARGET)-ld $(WORK_DIR)/shim/ld
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(TC_TARGET)-as $(WORK_DIR)/shim/as

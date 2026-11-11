###############################################################################
# spksrc.overlay/binutils.mk
#
# The binutils overlay, as native/binutils-<version> publishes it: <target>-{as,ld,...}
# under usr/local/bin, plus the unprefixed as/ld shim a compile reaches through -B
# (OVERLAY_BINUTILS_SHIM, spksrc.toolchain/overlay/binutils.mk).
###############################################################################

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv3

.PHONY: binutils-post_install
binutils-post_install:
	@mkdir -p $(WORK_DIR)/shim
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(TC_TARGET)-ld $(WORK_DIR)/shim/ld
	@ln -sf $(INSTALL_DIR)/usr/local/bin/$(TC_TARGET)-as $(WORK_DIR)/shim/as

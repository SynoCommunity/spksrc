###############################################################################
# spksrc.overlay/gcc.mk
#
# The gcc overlay, as native/gcc-<version> publishes it: a compiler beside the vendor one,
# named <target>-gcc-<version>, shipping no as/ld of its own -- those come from the binutils
# overlay of the same arch, composed here at install time. One archive per component, so
# either can be rebuilt without the other.
###############################################################################

PKG_NAME = gcc
PKG_EXT  = txz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(TC_TARGET)-$(OVERLAY_DIST_ARCH)-$(TC_VERS)-$(PKG_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2Fdsm$(TC_VERS)
EXTRACT_PATH  = $(INSTALL_DIR)

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GNU Compiler Collection
LICENSE  = GPLv3

INSTALL_TARGET      = nop
POST_INSTALL_TARGET = gcc-overlay-link

# The base toolchain's sysroot, under whichever name its layout uses, and the binutils
# overlay beside this one.
GCC_SYSROOT_DIR  = $(firstword $(wildcard $(addprefix $(abspath $(CURDIR)/../../toolchain/$(OVERLAY_TC)/work/$(TC_TARGET)/$(TC_TARGET))/,sys-root sysroot libc)))
GCC_BINUTILS_DIR = $(firstword $(wildcard $(abspath $(CURDIR)/..)/$(OVERLAY_TC)_binutils-*))

#   sysroot   gcc was configured --with-sysroot=<prefix>/<target>/<suffix>, which is what
#             makes it relocatable; this link is what makes that path real.
#   as / ld   gcc's driver looks in libexec/gcc/<target>/<vers>/ before PATH, and picks up
#             the HOST assembler if nothing is there. The -B shim covers compiles that
#             carry CFLAGS; this covers the ones that do not.
#   *.la      libtool archives bake the producer's DESTDIR into libdir; unusable here.
.PHONY: gcc-overlay-link
gcc-overlay-link:
	@test -n "$(GCC_SYSROOT_DIR)"  || { $(MSG) "gcc overlay: no sysroot under toolchain/$(OVERLAY_TC)" ; exit 1 ; }
	@test -n "$(GCC_BINUTILS_DIR)" || { $(MSG) "gcc overlay: no binutils overlay beside $(OVERLAY_TC)" ; exit 1 ; }
	@mkdir -p $(INSTALL_DIR)/usr/local/$(TC_TARGET)
	@ln -sfn $(GCC_SYSROOT_DIR) $(INSTALL_DIR)/usr/local/$(TC_TARGET)/$(notdir $(GCC_SYSROOT_DIR))
	@gccexec=$(INSTALL_DIR)/usr/local/libexec/gcc/$(TC_TARGET)/$(PKG_VERS) ; \
	 mkdir -p $${gccexec} ; \
	 for tool in as ld ; do \
	   ln -sf $(GCC_BINUTILS_DIR)/work/install/usr/local/bin/$(TC_TARGET)-$${tool} $${gccexec}/$${tool} ; \
	 done
	@find $(INSTALL_DIR) -name '*.la' -delete
	@$(MSG) "gcc overlay: linked sysroot + as/ld from $(notdir $(GCC_BINUTILS_DIR))"

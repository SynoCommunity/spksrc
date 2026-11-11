###############################################################################
# spksrc.overlay/gcc.mk
#
# The gcc overlay, as native/gcc-<version> publishes it: a compiler beside the vendor one,
# named <target>-gcc-<version>, shipping no as/ld of its own -- those come from the binutils
# overlay of the same arch, composed here at install time. One archive per component, so
# either can be rebuilt without the other.
###############################################################################

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GNU Compiler Collection
LICENSE  = GPLv3

# The base toolchain's sysroot, under whichever name its layout uses, and the binutils
# overlay beside this one.
GCC_SYSROOT_DIR  = $(firstword $(wildcard $(addprefix $(abspath $(CURDIR)/../../toolchain/$(OVERLAY_TC)/work/$(TC_TARGET)/$(TC_TARGET))/,sys-root sysroot libc)))
GCC_BINUTILS_DIR = $(firstword $(wildcard $(abspath $(CURDIR)/..)/$(OVERLAY_TC)_binutils-*))

.PHONY: gcc-post_install
gcc-post_install: gcc-link_sysroot gcc-link_as_ld gcc-drop_la
	@$(MSG) "gcc overlay: linked sysroot + as/ld from $(notdir $(GCC_BINUTILS_DIR))"

# gcc was configured --with-sysroot=<prefix>/<target>/<suffix>, which is what makes it
# relocatable; this link is what makes that path real.
.PHONY: gcc-link_sysroot
gcc-link_sysroot:
	@test -n "$(GCC_SYSROOT_DIR)" || { $(MSG) "gcc overlay: no sysroot under toolchain/$(OVERLAY_TC)" ; exit 1 ; }
	@mkdir -p $(INSTALL_DIR)/usr/local/$(TC_TARGET)
	@ln -sfn $(GCC_SYSROOT_DIR) $(INSTALL_DIR)/usr/local/$(TC_TARGET)/$(notdir $(GCC_SYSROOT_DIR))

# gcc's driver looks in libexec/gcc/<target>/<vers>/ before PATH, and picks up the HOST
# assembler if nothing is there. The -B shim covers compiles that carry CFLAGS; this
# covers the ones that do not.
.PHONY: gcc-link_as_ld
gcc-link_as_ld:
	@test -n "$(GCC_BINUTILS_DIR)" || { $(MSG) "gcc overlay: no binutils overlay beside $(OVERLAY_TC)" ; exit 1 ; }
	@gccexec=$(INSTALL_DIR)/usr/local/libexec/gcc/$(TC_TARGET)/$(PKG_VERS) ; \
	 mkdir -p $${gccexec} ; \
	 for tool in as ld ; do \
	   ln -sf $(GCC_BINUTILS_DIR)/work/install/usr/local/bin/$(TC_TARGET)-$${tool} $${gccexec}/$${tool} ; \
	 done

# libtool archives bake the producer's DESTDIR into libdir; unusable here.
.PHONY: gcc-drop_la
gcc-drop_la:
	@find $(INSTALL_DIR) -name '*.la' -delete

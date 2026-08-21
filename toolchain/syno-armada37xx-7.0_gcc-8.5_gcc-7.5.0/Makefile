TC_ARCH = armada37xx
TC_VERS = 7.0
TC_TARGET = aarch64-unknown-linux-gnu
# Archive to fetch: this arch's own, or the real arch whose toolchain a meta shares.
PKG_DIST_ARCH = $(TC_ARCH)

PKG_NAME = gcc
PKG_VERS = 8.5.0
PKG_EXT  = txz
PKG_REV ?= v1
EXTRACT_PATH = $(INSTALL_DIR)

DEPENDS =

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GNU Compiler Collection
LICENSE  = GPLv3

INSTALL_TARGET = nop
POST_INSTALL_TARGET = gcc-overlay-link

PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(TC_TARGET)-$(PKG_DIST_ARCH)-$(TC_VERS)-$(PKG_REV).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2Fdsm$(TC_VERS)

include ../../mk/spksrc.native-install.mk

# Siblings, resolved by directory name: ARCH/TCVERSION are unset in a toolchain dir,
# so overlay.mk's own pointers are empty here.
TC_BASE          = syno-$(TC_ARCH)-$(TC_VERS)
GCC_BINUTILS_DIR = $(firstword $(wildcard ../$(TC_BASE)_binutils-*))
GCC_SYSROOT_DIR  = $(firstword $(wildcard ../$(TC_BASE)/work/$(TC_TARGET)/$(TC_TARGET)/sys-root \
                                          ../$(TC_BASE)/work/$(TC_TARGET)/$(TC_TARGET)/sysroot \
                                          ../$(TC_BASE)/work/$(TC_TARGET)/$(TC_TARGET)/libc))

# Compose the two overlays at INSTALL time rather than baking binutils into the gcc
# archive: one archive per component stays the rule, and either can be rebuilt alone.
#
#   sysroot   gcc was configured --with-sysroot=<prefix>/<target>/<suffix>, which is what
#             makes it relocatable; this link is what makes that path real.
#   as / ld   gcc's driver looks in libexec/gcc/<target>/<vers>/ before PATH, and picks up
#             the HOST assembler if nothing is there. The -B shim covers compiles that
#             carry CFLAGS; this covers the ones that do not.
.PHONY: gcc-overlay-link
gcc-overlay-link:
	@test -n "$(GCC_SYSROOT_DIR)"  || { $(MSG) "gcc overlay: no sysroot under ../$(TC_BASE)" ; exit 1 ; }
	@test -n "$(GCC_BINUTILS_DIR)" || { $(MSG) "gcc overlay: no binutils overlay beside ../$(TC_BASE)" ; exit 1 ; }
	@mkdir -p $(INSTALL_DIR)/usr/local/$(TC_TARGET)
	@ln -sfn $(abspath $(GCC_SYSROOT_DIR)) $(INSTALL_DIR)/usr/local/$(TC_TARGET)/$(notdir $(GCC_SYSROOT_DIR))
	@gccexec=$(INSTALL_DIR)/usr/local/libexec/gcc/$(TC_TARGET)/$(PKG_VERS) ; \
	 mkdir -p $${gccexec} ; \
	 for tool in as ld ; do \
	   ln -sf $(abspath $(GCC_BINUTILS_DIR))/work/install/usr/local/bin/$(TC_TARGET)-$${tool} $${gccexec}/$${tool} ; \
	 done
	@$(MSG) "gcc overlay: linked sysroot + as/ld from $(notdir $(GCC_BINUTILS_DIR))"

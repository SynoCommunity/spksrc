PKG_NAME = libcap
PKG_VERS = 2.78
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Needs gcc >= 4.7: __atomic_test_and_set / __atomic_clear (libcap.h) rejected below.
MIN_GCC_VERSION = 4.7

# Needs binutils >= 2.25: the loader probe below reads empty's .interp with
# "objcopy --dump-section", which objcopy only learned in 2.25. Measured on the extracted
# toolchains, the boundary is exactly there -- ppc853x 2.18.50, 88f6281 and x86/x64-5.2
# 2.22 and hi3535 2.24 answer "unrecognized option", 2.25 and up all carry it. Those
# archs take libcap 2.51, which has no probe.
MIN_BINUTILS_VERSION = 2.25

HOMEPAGE = https://sites.google.com/site/fullycapable/
COMMENT  = POSIX 1003.1e capabilities (library). Libcap implements the user-space interfaces to the POSIX 1003.1e capabilities available in Linux kernels. These capabilities are a partitioning of the all powerful root privilege into a set of distinct privileges. 
LICENSE  = GPLv2

CONFIGURE_TARGET = nop
COMPILE_TARGET = libcap_compile
INSTALL_TARGET = libcap_install

ADDITIONAL_CFLAGS = -O2 -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

include ../../mk/spksrc.cross-cc.mk

# Make.Rules sets CC, AR, RANLIB and OBJCOPY with := , so the environment is ignored and
# each tool has to be named on the command line. BUILD_CC defaults to $(CC), which is why
# _makenames -- a generator run on the host -- gets an invocation of its own, with no CC.
#
# 'empty' is not a host tool: libcap compiles it for the target and reads its .interp back
# with objcopy, to bake the loader path into libcap.so (-DSHARED_LOADER). Built on the
# host it yields the host's loader instead. 2.78 compiles it with $(CFLAGS) too, which is
# what made that visible: the target flags now reach the host compiler, and it stops.
.PHONY: libcap_compile
libcap_compile:
	@$(MSG) Build _makenames for host
	@$(RUN) make -C libcap _makenames
	@$(MSG) Build libcap for $(ARCH)
	@$(RUN) make CC=$(call tc,gcc) AR=$(call tc,ar) RANLIB=$(call tc,ranlib) OBJCOPY=$(call tc,objcopy) -C libcap

# install libs only
# and force install in /lib rather than /lib64 for x86_64
.PHONY: libcap_install
libcap_install:
	@$(RUN) $(MAKE) lib=lib DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) -C libcap install

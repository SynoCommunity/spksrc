PKG_NAME = libcap
PKG_VERS = 2.70
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# missing support for atomics:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://sites.google.com/site/fullycapable/
COMMENT  = POSIX 1003.1e capabilities (library). Libcap implements the user-space interfaces to the POSIX 1003.1e capabilities available in Linux kernels. These capabilities are a partitioning of the all powerful root privilege into a set of distinct privileges. 
LICENSE  = GPLv2

CONFIGURE_TARGET = nop
COMPILE_TARGET = libcap_compile
INSTALL_TARGET = libcap_install

ADDITIONAL_CFLAGS = -O2 -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

include ../../mk/spksrc.cross-cc.mk

# empty and _makenames are run with "make libcap" and therefore must be compiled for the host (first)
.PHONY: libcap_compile
libcap_compile:
	@$(MSG) Build _makenames for host
	@$(RUN) make -C libcap empty _makenames
	@$(MSG) Build libcap for $(ARCH)
	@$(RUN) make CC=$(TC_PATH)$(TC_PREFIX)gcc -C libcap

# install libs only
# and force install in /lib rather than /lib64 for x86_64
.PHONY: libcap_install
libcap_install:
	@$(RUN) $(MAKE) lib=lib DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) -C libcap install

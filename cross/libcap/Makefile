PKG_NAME = libcap
PKG_VERS = 2.44
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sites.google.com/site/fullycapable/
COMMENT  = POSIX 1003.1e capabilities (library). Libcap implements the user-space interfaces to the POSIX 1003.1e capabilities available in Linux kernels. These capabilities are a partitioning of the all powerful root privilege into a set of distinct privileges. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_TARGET = nop
COMPILE_TARGET = libcap_compile
INSTALL_TARGET = libcap_install

ADDITIONAL_CFLAGS = -O2 -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

include ../../mk/spksrc.cross-cc.mk

# _makenames is run with "make libcap", therefore it must be compiled for the host (first)
.PHONY: libcap_compile
libcap_compile:
	@$(RUN) make -C libcap _makenames
	@$(RUN) make CC=$(TC_PATH)$(TC_PREFIX)gcc -C libcap
	@$(RUN) make CC=$(TC_PATH)$(TC_PREFIX)gcc -C progs

# force install in /lib rather than /lib64 for x86_64
# and install lib only (cross compile bin files does not work)
.PHONY: libcap_install
libcap_install:
	$(RUN) $(MAKE) lib=lib DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) -C libcap install
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) -C progs install

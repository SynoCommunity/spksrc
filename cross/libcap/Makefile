PKG_NAME = libcap
PKG_VERS = 2.31
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://sites.google.com/site/fullycapable/
COMMENT  = POSIX 1003.1e capabilities (library). Libcap implements the user-space interfaces to the POSIX 1003.1e capabilities available in Linux kernels. These capabilities are a partitioning of the all powerful root privilege into a set of distinct privileges. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_TARGET = nop
INSTALL_TARGET = libcap_install_target


include ../../mk/spksrc.cross-cc.mk

# force install in /lib rather than /lib64 for x86_64
.PHONY: libcap_install_target
libcap_install_target:
	$(RUN) $(MAKE) lib=lib DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) install

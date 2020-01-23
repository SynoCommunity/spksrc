PKG_NAME = fuse
PKG_VERS = 3.8.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/libfuse/releases/download/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/libfuse/libfuse
COMMENT  = The reference implementation of the Linux FUSE (Filesystem in Userspace) interface
LICENSE  = GPLv2, LGPLv2.1 (libfuse.so, libulockmgr.so)

CONFIGURE_TARGET = fuse_custom_configure
COMPILE_TARGET = fuse_custom_compile
INSTALL_TARGET = fuse_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: fuse_custom_configure fuse_custom_compile fuse_custom_install

fuse_custom_configure:
	$(RUN) mkdir -p build
	$(RUN) meson --prefix=$(INSTALL_PREFIX) -Dexamples=false build

fuse_custom_compile:
	$(RUN) ninja

fuse_custom_install:
	$(RUN) ninja install

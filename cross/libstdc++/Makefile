include ../../mk/spksrc.archs.mk

PKG_NAME = libstdc++6
PKG_VERS = 6.3.0-18+deb9u1
PKG_EXT = deb

PKG_ARCH = amd64
LIB_DIR = x86_64-linux-gnu
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_ARCH = armhf
LIB_DIR = arm-linux-gnueabihf
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_ARCH = arm64
LIB_DIR = aarch64-linux-gnu
endif

PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)_$(PKG_ARCH).deb
PKG_DIST_SITE = http://http.us.debian.org/debian/pool/main/g/gcc-6/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, Go, and D, as well as libraries for these languages (libstdc++,...). GCC was originally written as the compiler for the GNU operating system. The GNU system was developed to be 100% free software, free in the sense that it respects the user\'s freedom.
LICENSE  = GNU GPL v3

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = libstdc++6_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: libstdc++6_install
libstdc++6_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/usr/lib/$(LIB_DIR)/libstdc++.so.6.0.22 $(STAGING_INSTALL_PREFIX)/lib
	ln -s libstdc++.so.6.0.22 $(STAGING_INSTALL_PREFIX)/lib/libstdc++.so.6

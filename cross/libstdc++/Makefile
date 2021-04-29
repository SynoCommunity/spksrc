PKG_NAME = libstdc++6
PKG_VERS = 6.3.0-18+deb9u1
PKG_EXT = deb
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)_$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://http.us.debian.org/debian/pool/main/g/gcc-6/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

DEPENDS =

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, Go, and D, as well as libraries for these languages (libstdc++,...). GCC was originally written as the compiler for the GNU operating system. The GNU system was developed to be 100% free software, free in the sense that it respects the user\'s freedom.
LICENSE  = GPLv3

INSTALL_TARGET = libstdc++6_install

include ../../mk/spksrc.archs.mk

# use digests with multiple files
PKG_DIST_ARCH_LIST = amd64 armhf arm64 armel i386

PKG_DIST_ARCH = amd64
LIB_DIR = x86_64-linux-gnu
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
PKG_DIST_ARCH = armhf
LIB_DIR = arm-linux-gnueabihf
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
LIB_DIR = aarch64-linux-gnu
else ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
PKG_DIST_ARCH = armel
LIB_DIR = arm-linux-gnueabi
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PKG_DIST_ARCH = i386
LIB_DIR = i386-linux-gnu
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: libstdc++6_install
libstdc++6_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/usr/lib/$(LIB_DIR)/libstdc++.so.6.0.22 $(STAGING_INSTALL_PREFIX)/lib
	ln -s libstdc++.so.6.0.22 $(STAGING_INSTALL_PREFIX)/lib/libstdc++.so.6

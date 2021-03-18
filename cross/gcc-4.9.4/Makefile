PKG_NAME = gcc
PKG_VERS = 4.9.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp cross/mpfr cross/mpc cross/binutils

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, Go, and D, as well as libraries for these languages (libstdc++,...).
LICENSE  = GPLv2

GNU_CONFIGURE = 1
REQUIRE_KERNEL = 1

CONFIGURE_ARGS = --disable-bootstrap
CONFIGURE_ARGS += --enable-languages=c
#CONFIGURE_ARGS += --enable-languages=c,c++
CONFIGURE_ARGS += --disable-plugins
CONFIGURE_ARGS += --disable-multilib

# KERNEL
ADDITIONAL_CFLAGS += -I$(WORK_DIR)/linux/arch/$(ARCH)/include
ADDITIONAL_CPPFLAGS += -I$(WORK_DIR)/linux/arch/$(ARCH)/include

include ../../mk/spksrc.cross-cc.mk

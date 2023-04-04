PKG_NAME = gcc
#PKG_VERS = 5.5.0
#PKG_VERS = 6.5.0
#PKG_VERS = 6.5.0 # --> error: unknown type name '_OBSTACK_SIZE_T'
#PKG_VERS = 7.5.0 # --> error: unknown type name '_OBSTACK_SIZE_T'
PKG_VERS = 8.5.0
#PKG_VERS = 8.5.0 # --> error: unknown type name '_OBSTACK_SIZE_T'   
#PKG_VERS = 9.5.0 # --> error: unknown type name '_OBSTACK_SIZE_T'
#PKG_VERS = 10.4.0 # --> error +++++
#PKG_VERS = 11.3.0 # --> comme 10.4
#PKG_VERS = 12.2.0 # --> error: ‘__LIBGCC_SF_MAX__’ undeclared (first use in this function)
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

#DEPENDS = cross/gmp cross/mpfr cross/mpc cross/binutils
#DEPENDS = cross/zlib cross/gmp cross/mpfr cross/mpc cross/isl cross/cloog
DEPENDS = cross/zlib cross/gmp cross/mpfr cross/mpc

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, Go, and D, as well as libraries for these languages (libstdc++,...).
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = gcc_pre_configure

# Apply crosstool-NG patches
#PATCHES_LEVEL = 1

# https://gcc.gnu.org/install/configure.html
CONFIGURE_ARGS = --disable-bootstrap
#CONFIGURE_ARGS += --enable-languages=c
CONFIGURE_ARGS += --enable-languages=c,c++
#CONFIGURE_ARGS += --enable-languages=c,c++,fortran,go,objc,obj-c++
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-threads=posix
CONFIGURE_ARGS += --enable-clocale=gnu
CONFIGURE_ARGS += --disable-plugins
CONFIGURE_ARGS += --disable-multilib
CONFIGURE_ARGS += --with-system-zlib
#CONFIGURE_ARGS += --with-sysroot=$${SYSROOT}

CONFIGURE_ARGS  = --with-sysroot=$(TC_SYSROOT)
# all, default, ada, c, c++, d, fortran, go, jit, lto, m2, objc, obj-c++
CONFIGURE_ARGS += --enable-languages=c
#CONFIGURE_ARGS += --enable-languages=c,c++
#CONFIGURE_ARGS += --with-arch=i686
CONFIGURE_ARGS += --disable-tm-clone-registry
CONFIGURE_ARGS += --disable-multilib
CONFIGURE_ARGS += --enable-long-long
CONFIGURE_ARGS += --enable-default-pie
CONFIGURE_ARGS += --enable-__cxa_atexit
CONFIGURE_ARGS += --enable-cxx-flags=-D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS += --enable-libmudflap
CONFIGURE_ARGS += --enable-libgomp
CONFIGURE_ARGS += --enable-libssp
CONFIGURE_ARGS += --enable-libquadmath
CONFIGURE_ARGS += --enable-libquadmath-support
#CONFIGURE_ARGS += --enable-libsanitizer
#CONFIGURE_ARGS += --disable-libsanitizer
#CONFIGURE_ARGS += --disable-libiberty
#CONFIGURE_ARGS += libsanitizer_cv_sys_obstack=no
#CONFIGURE_ARGS += libsanitizer_cv_sys_obstack=no
CONFIGURE_ARGS += --enable-libmpx
# Uniquement sur x64?
#CONFIGURE_ARGS += --enable-lto
CONFIGURE_ARGS += --with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm'
CONFIGURE_ARGS += --enable-threads=posix
# Specify that target libraries should be optimized for code space instead of code speed.
CONFIGURE_ARGS += --enable-target-optspace
CONFIGURE_ARGS += --disable-plugin
CONFIGURE_ARGS += --enable-gold
CONFIGURE_ARGS += --enable-version-specific-runtime-libs
# Si pas c++ alors ne sert a rien
#CONFIGURE_ARGS += --with-gxx-include-dir=$(WORK_DIR)/$(STAGING_INSTALL_PREFIX)/include/c++/$(PKG_VERS)
#CONFIGURE_ARGS += --program-prefix=i686-syno_r1000-linux-gnu-
CONFIGURE_ARGS += --program-suffix=-8.5

# Define if you want to use __cxa_atexit, rather than atexit, to register C++ destructors
# for local statics and global objects. This is essential for fully standards-compliant
# handling of destructors, but requires __cxa_atexit in libc.
# *** This option is currently only available on systems with GNU libc.***
# When enabled, this will cause -fuse-cxa-atexit to be passed by default.
#CONFIGURE_ARGS += --enable-__cxa_atexit

# Otherwise will fail on any error
ADDITIONAL_CFLAGS += -Wno-error
#ADDITIONAL_CFLAGS += -fno-operator-names
#ADDITIONAL_CPPFLAGS += -fno-operator-names
#ADDITIONAL_CFLAGS += -std=gnu99
#ADDITIONAL_CFLAGS += -std=c99
#ADDITIONAL_CXXFLAGS += -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH
#ADDITIONAL_CXXFLAGS += -D_GLIBCXX_HAVE_OBSOLETE_ISNAN -D_GLIBCXX_HAVE_OBSOLETE_ISINF
#ADDITIONAL_CXXFLAGS += -D_OBSTACK_INTERFACE_VERSION=1
#ADDITIONAL_CFLAGS += -D_OBSTACK_INTERFACE_VERSION=1
ADDITIONAL_CFLAGS += -I/home/spksrc/gdb/spksrc/cross/gcc/work-x64-7.1/gcc-6.5.0/include
ADDITIONAL_CXXFLAGS += -I/home/spksrc/gdb/spksrc/cross/gcc/work-x64-7.1/gcc-6.5.0/include
ADDITIONAL_CPPFLAGS += -I/home/spksrc/gdb/spksrc/cross/gcc/work-x64-7.1/gcc-6.5.0/include

include ../../mk/spksrc.cross-cc.mk

.PHONY: gcc_pre_configure
gcc_pre_configure:
	@echo CONFIGURE_ARGS: $(CONFIGURE_ARGS)
	@echo TC_SYSROOT: $(TC_SYSROOT)
	@echo TC_SYSROOT: $${TC_SYSROOT}
	@echo SYSROOT: $${SYSROOT}
	@echo GLIBC -I$(TC_SYSROOT)/usr/include

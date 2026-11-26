PKG_NAME = firebird
PKG_VERS = 4.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/FirebirdSQL/firebird/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libicu native/libicu native/libtool

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# Create proper src/make.synology.evansport to support this
UNSUPPORTED_ARCHS += $(i686_ARCHS)

# Uses too old GCC 4.9
UNSUPPORTED_ARCHS += comcerto2k

include ../../mk/spksrc.common.mk

# Currently v4.0.2 works only with 7.0 and 7.1
# DSM 7.2 has issues with GLIBC version
# DSM 6.x has issues with some C++ libraries versions
ifeq ($(call version_lt,$(TCVERSION),7.0)$(call version_gt,$(TCVERSION),7.1),1)
UNSUPPORTED_ARCHS += $(ARCH)
endif

HOMEPAGE = https://www.firebirdsql.org/
COMMENT  = Firebird is a relational database offering many ANSI SQL standard features that runs on Linux, Windows, MacOS and a variety of Unix platforms.
LICENSE  = MPL
MAINTAINER = vitkabele

PRE_CONFIGURE_TARGET = firebird_pre_configure

CONFIGURE_TARGET = firebird_configure

COMPILE_TARGET = firebird_compile

INSTALL_TARGET = firebird_install

# We must forward-declare the PKGVAR here as we must compile its value to the
# binaries. We only support DSM7 so we do not worry about DSM6 compatibility
SYNOPKG_PKGVAR = /var/packages/$(PKG_NAME)/var
SYNOPKG_PKGDEST = /var/packages/$(PKG_NAME)/target

ADDITIONAL_CFLAGS = '-DFB_PREFIX="\"$(SYNOPKG_PKGDEST)\""' \
					'-DFB_SECDBDIR="\"$(SYNOPKG_PKGVAR)\""' \
					'-DFB_GUARDDIR="\"$(SYNOPKG_PKGVAR)\""' \
					'-DFB_CONFDIR="\"$(SYNOPKG_PKGVAR)\""' \
					'-DFB_SBINDIR="\"$(SYNOPKG_PKGDEST)/bin\""' \
					'-DFB_BINDIR="\"$(SYNOPKG_PKGDEST)/bin\""' \
					'-DFB_DOCDIR="\"$(SYNOPKG_PKGDEST)/doc\""' \
					'-DFB_HELPDIR="\"$(SYNOPKG_PKGDEST)/help\""' \
					'-DFB_SAMPLEDIR="\"$(SYNOPKG_PKGDEST)/examples\""' \
					'-DFB_PLUGDIR="\"$(SYNOPKG_PKGDEST)/plugins\""' \
					'-DFB_SAMPLEDBDIR="\"$(SYNOPKG_PKGDEST)/examples/empbuild\""' \
					'-DFB_TZDATADIR="\"$(SYNOPKG_PKGDEST)\""' \
					'-DFB_MISCDIR="\"$(SYNOPKG_PKGDEST)/misc\""' \
					'-DFB_MSGDIR="\"$(SYNOPKG_PKGDEST)\""' \
					'-DFB_INCDIR="\"$(SYNOPKG_PKGDEST)/include\""' \
					'-DFB_INTLDIR="\"$(SYNOPKG_PKGDEST)/intl\""' \
					'-DFB_LIBDIR="\"$(SYNOPKG_PKGDEST)/lib\""' \
					'-DFB_LOGDIR="\"$(SYNOPKG_PKGVAR)\""'

# CXXFLAGS should be set fine by the spksrc for cross-compilation, we will
# use it in cross2 step CROSS_ENV
ADDITIONAL_CXXFLAGS = -Wno-invalid-offsetof $(ADDITIONAL_CFLAGS)

# Path to the libtool installed in the cross/libtool DEPENDS target
# We need the native libtool for building libommath/libtomcrypt in cross1 step
LIBTOOL_BIN = $(WORK_DIR)/../../../native/libtool/work-native/install/usr/local/bin/libtool

# We need both native and cross compilers for building the binary.
include ../../mk/spksrc.cross-cc.mk

# If we use --with-builtin-tomcrypt/math, the libraries are built during cross1
# phase without -fPIC and then refuse to link during cross2 phase. Further,
# they can be built for different platforms during cross1 and cross2 phase.
#
# termlib and editline are disabled because we don't provide ncurses
# and editline libraries
CONFIGURE_ARGS = --without-termlib --with-builtin-tommath --with-builtin-tomcrypt \
				 --without-editline --with-cross-build=synology.$(ARCH) --prefix=$(INSTALL_PREFIX) \
				 --with-fbconf=$(INSTALL_PREFIX)/var

NATIVE_LIBICU_DIR := $(WORK_DIR)/../../../native/libicu/work-native/install/usr/local

# CFLAGS and CXXFLAGS for cross1 compile stage
NATIVE_CFLAGS := -I$(NATIVE_LIBICU_DIR)/include -L$(NATIVE_LIBICU_DIR)/lib

# Preprocessor flags
NATIVE_CPPFLAGS := -I$(NATIVE_LIBICU_DIR)/include 

# This ENV is for cross1 phase where we build native target
#
# The NATIVE flags must be passed to the configure part, because the configure
# fails when it cant find the headers.
NATIVE_ENV = CC=gcc CXX=g++ AS=as AR=ar LD=ld NM=nm OBJCOPY=objcopy OBJDUMP=objdump \
	  PARALLEL_MAKE=max \
	  LIBTOOL="$(LIBTOOL_BIN)" \
	  CFLAGS="$(NATIVE_CFLAGS)" \
	  CXXFLAGS="$(NATIVE_CFLAGS)" \
	  CPPFLAGS="$(NATIVE_CPPFLAGS)"

NATIVE_RUN = cd $(WORK_DIR)/$(PKG_DIR) && env $(NATIVE_ENV)

# DO NOT MODIFY $(ENV) variable (too much) a.k.a. only add variables for ourselves
# and do not modify any CFLAGS or other universally recognized variable
# It breaks compilation of dependent cross/* libraries (especially cross/libicu)
#
# This ENV is for cross2 build phase where we build binaries for target platform
# CROSS_ prefixed vars are for the cross2 phase and we "strip" the CROSS_ prefix
# in our provided src/makefile.xxx
#
# The C(XX)FLAGS variables are ready by the spksrc for cross compilation, we
# just use them
ENV += CROSS_TOOLCHAIN=$(TC_PATH)$(TC_PREFIX)

.PHONY: firebird_pre_configure
firebird_pre_configure:
	cp src/make.synology.* $(WORK_DIR)/$(PKG_DIR)/builds/posix/
	cp src/cross_config/* $(WORK_DIR)/$(PKG_DIR)/src/include/cross/
	$(NATIVE_RUN) NOCONFIGURE=1 ./autogen.sh

# Override the configure target, because we must pass it different env than
# ENV. We cannot modify ENV to contain -I for native/libicu, because it breaks
# compilation of native/libicu, but we must have this -I in the configure
# CFLAGS, otherwise the configure step fails with unicode headers not found.
.PHONY: firebird_configure
firebird_configure:
	$(NATIVE_RUN) ./configure $(CONFIGURE_ARGS)

# Firebird itself would be compiled by simple make, but we must pass different
# environment to cross1 and cross2 step. The toolchain and CFLAGS differ
.PHONY: firebird_compile
firebird_compile:
	$(NATIVE_RUN) make TARGET=Native cross1
	$(RUN) make TARGET=Release CROSS_OUT=Y cross2

.PHONY: firebird_install
firebird_install:
	$(RUN) make TARGET=Release CROSS_OUT=Y dist
	# We assume there is just one buildroot.tar.gz file in the build tree
	# This is a little hack since we don't know the exact path where it is
	# produced and it is easier than patching the firebird Makefiles
	cd $(WORK_DIR)/install && tar xf $$(find ../ -name buildroot.tar.gz)


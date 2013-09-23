PKG_NAME = gcc
PKG_VERS = 4.7.3
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/gmp native/mpfr native/mpc native/binutils

HOMEPAGE = http://gcc.gnu.org
COMMENT  = The GNU Compiler Collection
LICENSE  = GPL

HOST_ARCH = $(shell getconf LONG_BIT)
ifeq ($(HOST_ARCH),64)
LIBDIR=lib64
else
LIBDIR=lib
endif


CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall


ifeq ($(findstring $(ARCH), bromolow cedarview x86 88f6281 88f5281 armada370 powerpc ppc824x ppc853x ppc854x qoriq),)
$(error This package is part of a toolchain. To use this packages, please run: spk/toolchain-gcc47 arch-<arch> )
endif

include ../../local.mk
ifeq ($(findstring $(MAKE_TOOLCHAIN_ARCH), bromolow cedarview x86 88f6281 88f5281 armada370 powerpc ppc824x ppc853x ppc854x qoriq),)
$(error This package is part of a toolchain. To use this packages, please run: spk/toolchain-gcc47 arch-<arch> )
endif

ifeq ($(MAKE_TOOLCHAIN_GCC_VER),47)
TOOLCHAIN_PATH = $(WORK_DIR)/../../../toolchains/syno-$(MAKE_TOOLCHAIN_ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/work/$(MAKE_TOOLCHAIN_TARGET)
else
$(error This package is part of a toolchain. To use this packages, please run: spk/toolchain-gcc47 arch-<arch> )
endif


COOKIE_PREFIX=$(PKG_NAME)-$(MAKE_TOOLCHAIN_ARCH)-


CONFIGURE_ARGS =  --build=$$BUILD_HOST --host=$$BUILD_HOST --target=$(MAKE_TOOLCHAIN_TARGET)
CONFIGURE_ARGS += --prefix=$(TOOLCHAIN_PATH)
CONFIGURE_ARGS += --with-local-prefix=$(TOOLCHAIN_PATH)
CONFIGURE_ARGS += --with-sysroot=$(TOOLCHAIN_PATH)/$(MAKE_TOOLCHAIN_TARGET)/sys-root

CONFIGURE_ARGS += --disable-nls --disable-shared --without-headers
CONFIGURE_ARGS += --with-newlib --disable-decimal-float --disable-libgomp
CONFIGURE_ARGS += --disable-libmudflap --disable-libssp --disable-threads
CONFIGURE_ARGS += --enable-languages=c --disable-multilib

CONFIGURE_ARGS += --with-gmp-include=$(WORK_DIR)/../../gmp/work-native/install/usr/local/include
CONFIGURE_ARGS += --with-gmp-lib=$(WORK_DIR)/../../gmp/work-native/install/usr/local/$(LIBDIR)
CONFIGURE_ARGS += --with-mpfr-include=$(WORK_DIR)/../../mpfr/work-native/install/usr/local/include
CONFIGURE_ARGS += --with-mpfr-lib=$(WORK_DIR)/../../mpfr/work-native/install/usr/local/$(LIBDIR)
CONFIGURE_ARGS += --with-mpc-include=$(WORK_DIR)/../../mpc/work-native/install/usr/local/include
CONFIGURE_ARGS += --with-mpc-lib=$(WORK_DIR)/../../mpc/work-native/install/usr/local/$(LIBDIR)


include ../../mk/spksrc.native-cc.mk


.PHONY: myConfigure
myConfigure:
	$(RUN) echo ; \
		cd .. ; \
		mkdir -p work-$(MAKE_TOOLCHAIN_ARCH)/build ; \
		if [ -f $(PKG_DIR)/configure ] ; then mv $(PKG_DIR) work-$(MAKE_TOOLCHAIN_ARCH) ; fi ; \
		mkdir -p $(PKG_DIR) ; \
		cd work-$(MAKE_TOOLCHAIN_ARCH)/$(PKG_DIR) ; \
		sed -i "s@TOOLCHAIN=@TOOLCHAIN=/usr/local/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)@" ld_prefix-fix.sh ; \
		bash ld_prefix-fix.sh ; \
		export BUILD_HOST=`echo ${MACHTYPE} | sed -e 's/-\([^-]*\)/-build_\1/'` ; \
		cd ../build ; \
		AR=ar LDFLAGS="-Wl,-rpath,$(TOOLCHAIN_PATH)/$(LIBDIR)" ../$(PKG_DIR)/configure $(CONFIGURE_ARGS)

.PHONY: myCompile
myCompile:
	$(RUN) echo ; \
		cd ../work-$(MAKE_TOOLCHAIN_ARCH)/build ; \
		make $(MAKE_OPT) all-gcc  all-target-libgcc

.PHONY: myInstall
myInstall:
	$(RUN) echo ; \
		cd ../work-$(MAKE_TOOLCHAIN_ARCH)/build ; \
		make install-gcc  install-target-libgcc

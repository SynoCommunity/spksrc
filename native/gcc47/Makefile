PKG_NAME = gcc
PKG_VERS = 4.7.3
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

#ifneq ($(findstring $(ARCH), bromolow cedarview x86 88f6281, powerpc),)
DEPENDS = native/glibc
#else ifneq ($(findstring $(ARCH), 88f6281),)
#DEPENDS = native/eglibc
#else
#DEPENDS =
#endif

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


ifeq ($(MAKE_TOOLCHAIN_TARGET),)
$(error This package is part of a toolchain. To use this packages, please run: spk/toolchain-gcc47 arch-<arch> )
endif

ifeq ($(MAKE_TOOLCHAIN_GCC_VER),47)
TOOLCHAIN_PATH = $(WORK_DIR)/../../../toolchains/syno-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/work/$(MAKE_TOOLCHAIN_TARGET)
else
$(error This package is part of a toolchain. To use this packages, please run: spk/toolchain-gcc47 arch-<arch> )
endif


COOKIE_PREFIX=$(PKG_NAME)-$(ARCH)-


CONFIGURE_ARGS =  --build=$$BUILD_HOST --host=$$BUILD_HOST --target=$(MAKE_TOOLCHAIN_TARGET)
CONFIGURE_ARGS += --prefix=$(TOOLCHAIN_PATH)
CONFIGURE_ARGS += --with-local-prefix=$(TOOLCHAIN_PATH)
CONFIGURE_ARGS += --with-sysroot=$(TOOLCHAIN_PATH)/$(MAKE_TOOLCHAIN_TARGET)/sys-root

CONFIGURE_ARGS += --enable-clocale=gnu --enable-shared --enable-threads=posix
CONFIGURE_ARGS += --enable-__cxa_atexit --enable-languages=c,c++ --disable-libstdcxx-pch
CONFIGURE_ARGS += --disable-multilib --disable-bootstrap --disable-libgomp

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
		mkdir -p work-$(ARCH)/build ; \
		if [ -f $(PKG_DIR)/configure ] ; then mv $(PKG_DIR) work-$(ARCH) ; fi ; \
		mkdir -p $(PKG_DIR) ; \
		cd work-$(ARCH)/$(PKG_DIR) ; \
		sed -i "s@TOOLCHAIN=@TOOLCHAIN=/usr/local/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)@" ld_prefix-fix.sh ; \
		bash ld_prefix-fix.sh ; \
		export BUILD_HOST=`echo ${MACHTYPE} | sed -e 's/-\([^-]*\)/-build_\1/'` ; \
		cd ../build ; \
		AR=ar LDFLAGS="-Wl,-rpath,$(TOOLCHAIN_PATH)/$(LIBDIR)" ../$(PKG_DIR)/configure $(CONFIGURE_ARGS)

.PHONY: myCompile
myCompile:
	$(RUN) echo ; \
		cd ../work-$(ARCH)/build ; \
		make $(MAKE_OPT)

.PHONY: myInstall
myInstall:
	$(RUN) echo ; \
		cd ../work-$(ARCH)/build ; \
		make install

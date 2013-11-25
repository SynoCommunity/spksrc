PKG_NAME = glibc
PKG_VERS = 2.18
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/pub/gnu/libc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

ifeq ($(MAKE_TOOLCHAIN_GCC_VER),47)
DEPENDS = native/binutils native/gcc47-bootstrap
else
ifeq ($(MAKE_TOOLCHAIN_GCC_VER),48)
DEPENDS = native/binutils native/gcc48-bootstrap
endif
endif

REQ_KERNEL = 1

HOMEPAGE = http://www.gnu.org/software/libc/
COMMENT  = The GNU C Library
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
$(error This package is part of a toolchain. Please start with the package: spk/toolchain-gcc[47|48] arch-<arch> )
endif

ifneq ($(findstring $(MAKE_TOOLCHAIN_GCC_VER), 47 48),)
TOOLCHAIN_PATH = $(WORK_DIR)/../../../toolchains/syno-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/work/$(MAKE_TOOLCHAIN_TARGET)
else
$(error This package is part of a toolchain. Please start with the package: spk/toolchain-gcc[47|48] arch-<arch> )
endif

ifneq ($(findstring $(ARCH), bromolow cedarview x86),)
ARCH_LIBDIR=lib64
else
ARCH_LIBDIR=lib
endif


COOKIE_PREFIX=$(PKG_NAME)-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)-


CONFIGURE_ARGS =  --prefix=$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)
CONFIGURE_ARGS += --includedir=$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)/usr/include
CONFIGURE_ARGS += --libdir=$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)/usr/$(ARCH_LIBDIR)
CONFIGURE_ARGS += --libexecdir=$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)/usr/$(ARCH_LIBDIR)
CONFIGURE_ARGS += --datarootdir=$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)/usr/share
CONFIGURE_ARGS += --datadir=$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)/usr/share
CONFIGURE_ARGS += --host=$(MAKE_TOOLCHAIN_TARGET) --build=$$BUILD_HOST
CONFIGURE_ARGS += --with-headers=$(TOOLCHAIN_PATH)/include
CONFIGURE_ARGS += --with-binutils=$(TOOLCHAIN_PATH)/bin
CONFIGURE_ARGS += --disable-profile --enable-kernel=2.6.25
CONFIGURE_ARGS += libc_cv_forced_unwind=yes libc_cv_ctors_header=yes libc_cv_c_cleanup=yes
CONFIGURE_ARGS += libc_cv_slibdir=$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)/$(ARCH_LIBDIR)


include ../../mk/spksrc.native-cc.mk


.PHONY: myConfigure
myConfigure:
	$(RUN) /bin/bash -c '\
		cp -r $(WORK_DIR)/../../../kernel/syno-$(ARCH)/work/include/* $(TOOLCHAIN_PATH)/include ; \
		cp -r $(WORK_DIR)/../../../kernel/syno-$(ARCH)/work/include/* $(TOOLCHAIN_PATH)/$(MAKE_TOOLCHAIN_TARGET)/sys-root/usr/include ; \
		export BUILD_HOST=`echo ${MACHTYPE} | sed -e 's/-\([^-]*\)/-build_\1/'` ; \
		export PATH=$(TOOLCHAIN_PATH)/bin:${PATH} ; \
		cd .. ; \
		mkdir -p work-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/build ; \
		if [ -f $(PKG_DIR)/configure ] ; then mv $(PKG_DIR) work-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER) ; fi ; \
		mkdir -p $(PKG_DIR) ; \
		cd work-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/build ; \
		BUILD_CC="gcc" CC="$(MAKE_TOOLCHAIN_TARGET)-gcc" \
		AR="$(MAKE_TOOLCHAIN_TARGET)-ar" RANLIB="$(MAKE_TOOLCHAIN_TARGET)-ranlib" \
		../$(PKG_DIR)/configure $(CONFIGURE_ARGS)'

.PHONY: myCompile
myCompile:
	$(RUN) /bin/bash -c '\
		export PATH=$(TOOLCHAIN_PATH)/bin:${PATH} ; \
		cd ../work-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/build ; \
		make $(MAKE_OPT)'

.PHONY: myInstall
myInstall:
	$(RUN) /bin/bash -c '\
		export PATH=$(TOOLCHAIN_PATH)/bin:${PATH} ; \
		cd ../work-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/build ; \
		make install_root=$(INSTALL_DIR)-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER) install ; \
		cp -a $(INSTALL_DIR)-$(ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/$(INSTALL_PREFIX)/toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER)/* $(TOOLCHAIN_PATH)/$(MAKE_TOOLCHAIN_TARGET)/sys-root ; \
		mkdir -p $(TOOLCHAIN_PATH)/$(MAKE_TOOLCHAIN_TARGET)/sys-root/usr/local ; \
		pushd $(TOOLCHAIN_PATH)/$(MAKE_TOOLCHAIN_TARGET)/sys-root/usr/local ; \
		if [ ! -d toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER) ] ; then ln -sf ../../../sys-root toolchain-gcc$(MAKE_TOOLCHAIN_GCC_VER) ; fi ; \
		popd'

PKG_NAME = toolchain-gcc48
PKG_VERS = 1.0.0
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ximi1970/spksrc-toolchain/archive

DEPENDS = native/gcc48

HOMEPAGE = https://github.com/SynoCommunity/spksrc
COMMENT  = Toolchain is a container for a collection of GNU programming tools.
LICENSE  =

HOST_ARCH = $(shell getconf LONG_BIT)
ifeq ($(HOST_ARCH),64)
LIBDIR=lib64
else
LIBDIR=lib
endif


PRE_DEPEND_TARGET = myPreDepend
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall


ifeq ($(findstring $(ARCH), bromolow cedarview x86 88f6281 88f5281 armada370 powerpc ppc824x ppc853x ppc854x qoriq),)
$(error This package is part of a toolchain. Please start with the package: spk/toolchain-gcc48 arch-<arch> )
endif

include ../../local.mk
ifeq ($(findstring $(MAKE_TOOLCHAIN_ARCH), bromolow cedarview x86 88f6281 88f5281 armada370 powerpc ppc824x ppc853x ppc854x qoriq),)
$(error This package is part of a toolchain. Please start with the package: spk/toolchain-gcc48 arch-<arch> )
endif

ifeq ($(MAKE_TOOLCHAIN_GCC_VER),48)
TOOLCHAIN_PATH = $(WORK_DIR)/../../../toolchains/syno-$(MAKE_TOOLCHAIN_ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/work/$(MAKE_TOOLCHAIN_TARGET)
else
$(error This package is part of a toolchain. Please start with the package: spk/toolchain-gcc48 arch-<arch> )
endif

ifneq ($(findstring $(ARCH), bromolow cedarview x86),)
ARCH_LIBDIR=lib64
else
ARCH_LIBDIR=lib
endif


COOKIE_PREFIX=$(PKG_NAME)-$(MAKE_TOOLCHAIN_ARCH)-


include ../../mk/spksrc.native-cc.mk

.PHONY: myPreDepend
myPreDepend:
	$(RUN) echo ; \
		mkdir -p $(TOOLCHAIN_PATH) ; \
		pushd $(TOOLCHAIN_PATH) ; \
		mkdir -p include ; \
		mkdir -p lib ; \
		if [ ! -d lib64 ] && [ "$(LIBDIR)" == "lib64" ] ; then ln -sf lib lib64 ; fi ; \
		mkdir -p $(MAKE_TOOLCHAIN_TARGET)/sys-root/usr/include ; \
		mkdir -p $(MAKE_TOOLCHAIN_TARGET)/sys-root/usr/$(ARCH_LIBDIR) ; \
		pushd $(MAKE_TOOLCHAIN_TARGET) ; \
		if [ ! -d include ] ; then ln -sf sys-root/usr/include include ; fi ; \
		if [ ! -d $(ARCH_LIBDIR) ] ; then ln -sf sys-root/usr/$(ARCH_LIBDIR) $(ARCH_LIBDIR) ; fi ; \
		if [ ! -d lib ] ; then ln -sf $(ARCH_LIBDIR) lib ; fi ; \
		popd ; \
		popd

.PHONY: myConfigure
myConfigure:
	$(RUN) echo ; \
		rm -rf work-$(MAKE_TOOLCHAIN_ARCH) ; \
		mkdir -p work-$(MAKE_TOOLCHAIN_ARCH) ; \
		if [ -f *-$(PKG_NAME)-$(PKG_VERS)/README.md ] ; then mv *-$(PKG_NAME)-$(PKG_VERS) work-$(MAKE_TOOLCHAIN_ARCH) ; fi

.PHONY: myCompile
myCompile:

.PHONY: myInstall
myInstall:

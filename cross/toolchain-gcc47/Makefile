PKG_NAME = toolchain-gcc47
PKG_VERS = 1.0.0
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ximi1970/spksrc-toolchain/archive

DEPENDS = native/$(PKG_NAME)

HOMEPAGE = https://github.com/SynoCommunity/spksrc
COMMENT  = Toolchain is a container for a collection of GNU programming tools.
LICENSE  = GNU GPL


CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall


include ../../local.mk
ifeq ($(findstring $(MAKE_TOOLCHAIN_ARCH), bromolow cedarview x86 88f6281 88f5281 armada370 powerpc ppc824x ppc853x ppc854x qoriq),)
$(error This package is part of a toolchain. Please start with the package: spk/toolchain-gcc47 arch-<arch> )
endif

ifeq ($(MAKE_TOOLCHAIN_GCC_VER),47)
TOOLCHAIN_PATH = $(WORK_DIR)/../../../toolchains/syno-$(MAKE_TOOLCHAIN_ARCH)-gcc$(MAKE_TOOLCHAIN_GCC_VER)/work/$(MAKE_TOOLCHAIN_TARGET)
else
$(error This package is part of a toolchain. Please start with the package: spk/toolchain-gcc47 arch-<arch> )
endif


include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:

.PHONY: myCompile
myCompile:

.PHONY: myInstall
myInstall:
	$(RUN) mkdir -p $(INSTALL_DIR)
	$(RUN) cp -a $(TOOLCHAIN_PATH)/$(MAKE_TOOLCHAIN_TARGET)/sys-root/* $(INSTALL_DIR)/$(INSTALL_PREFIX)
	$(RUN) cp -f $(WORK_DIR)/../../../cross/$(PKG_NAME)/PLIST.$(ARCH) $(WORK_DIR)/PLIST

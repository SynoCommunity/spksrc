PKG_NAME = RHash
PKG_VERS = 1.3.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rhash/RHash/archive
PKG_DIST_FILE=$(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://rhash.sourceforge.net/
COMMENT = RHash is a console utility for computing and verifying hash sums of files.
LICENSE = MIT


ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=arm-linux
endif
ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=arm-linux
endif
ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=aarch64-linux
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=ppc-linux
endif
ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=x86-linux
endif
ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=x86_64-linux
endif
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX) --enable-symlinks --enable-static

include ../../mk/spksrc.cross-cc.mk

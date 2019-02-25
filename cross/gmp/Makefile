PKG_NAME = gmp
PKG_VERS = 6.1.2
PKG_EXT = tar.lz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gmplib.org/download/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://gmplib.org/
COMMENT  = GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers
LICENSE  = LGPL

GNU_CONFIGURE = 1

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=arm-unknown-linux-gnueabi --host=arm-unknown-linux-gnueabi --disable-assembly
endif
ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=arm-unknown-linux-gnueabi --host=arm-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=aarch64-unknown-linux-gnu --host=aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=powerpc-unknown-linux-gnu --host=powerpc-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=i686-pc-linux-gnu --host=i686-pc-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu
endif

include ../../mk/spksrc.cross-cc.mk

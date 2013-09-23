PKG_NAME = gmp
PKG_VERS = 5.1.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gmplib.org/pub/gmp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://gmplib.org/
COMMENT  = The GNU Multiple Precision Arithmetic Library
LICENSE  = LGPL

HOST_ARCH = $(shell getconf LONG_BIT)
ifeq ($(HOST_ARCH),64)
ARCH_ABI=64
else
ARCH_ABI=32
endif


COMPILE_TARGET = myCompile


GNU_CONFIGURE = 1
CONFIGURE_ARGS = ABI=$(ARCH_ABI)


include ../../mk/spksrc.native-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) make $(MAKE_OPT)
	$(RUN) make check

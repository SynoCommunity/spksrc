PKG_NAME = yasm
PKG_VERS = 1.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.tortall.net/projects/$(PKG_NAME)/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.tortall.net
COMMENT  = Yasm is a complete rewrite of the NASM-2.11.08 assembler. It supports the x86 and AMD64 instruction sets, accepts NASM and GAS assembler syntaxes and outputs binary, ELF32 and ELF64 object formats.
LICENSE  =

CONFIGURE_ARGS = --prefix=$(INSTALL_PREFIX)
CONFIGURE_TARGET = myConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) sed -i 's#) ytasm.*#)#' Makefile.in
	$(RUN) ./configure $(TC_CONFIGURE_ARGS) $(CONFIGURE_ARGS)


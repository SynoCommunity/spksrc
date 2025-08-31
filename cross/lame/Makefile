PKG_NAME = lame
PKG_VERS = 3.100
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/lame/lame/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://lame.sourceforge.net/
COMMENT  = High quality MPEG Audio Layer III encoder.
LICENSE  = LGPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --disable-static

# Remarks:
# nasm is autodetected and used for evansport (i386) only
# 
# we cannot activate NASM for x64 archs (checking for assembler routines for this processor type... no)
# and we cannot deactivate NASM for evansport (checking for assembler routines for this processor type... yes)
# none of the following args change anything related to nasm:
# --enable-nasm
# --disable-nasm
#ENV += NASM=$(shell which nasm)

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

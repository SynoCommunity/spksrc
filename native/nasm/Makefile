PKG_NAME = nasm
PKG_VERS = 2.16.03
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/netwide-assembler/nasm/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.nasm.us/ or https://github.com/netwide-assembler/nasm
COMMENT  = The Netwide Assembler (NASM), an asssembler for the x86 CPU architecture portable to nearly every modern platform, and with code generation for many platforms old and new.
LICENSE  = 2-clause BSD

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = nasm_pre_configure

include ../../mk/spksrc.native-cc.mk

.PHONY: nasm_pre_configure
nasm_pre_configure:
	$(RUN) ./autogen.sh

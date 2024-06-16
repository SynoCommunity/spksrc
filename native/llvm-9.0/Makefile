PKG_NAME = llvm
PKG_VERS = 9.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = native-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/native%2Fllvm
EXTRACT_PATH = $(WORK_DIR)

DEPENDS = 

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE  = Apache License v2.0 with LLVM Exceptions

# extracted directly into install folder
INSTALL_TARGET = nop

include ../../mk/spksrc.native-install.mk

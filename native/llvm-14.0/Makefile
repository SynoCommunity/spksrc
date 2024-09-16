PKG_NAME = llvm
PKG_VERS = 14.0.5
PKG_VERS_MAJ = $(firstword $(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.gz
PKG_DIST_NAME = native-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/native%2Fllvm
EXTRACT_PATH = $(WORK_DIR)

# REMARKS:
# Since it takes a huge amount of resources to build this, we started to host the 
# output on https://github.com/SynoCommunity/spksrc/releases/tag/native%2Fllvm
# 
# This Makefile is to build the native llvm
# and has one additional target to build the archive (make build-archive)
# 
# The main reason to build llvm from source is, that other prebuilt packages
# do not contain the binary "clang-tblgen" that is mandatory to build cross/llvm-14.0.
# 

DEPENDS =

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE = Apache v2.0 with LLVM Exceptions

INSTALL_TARGET = nop

include ../../mk/spksrc.native-install.mk

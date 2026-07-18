# GCC 8.5 overlay for syno-x64-5.2 (consumer, llvm/rust-overlay style). Downloads the
# prebuilt gcc-8.5 archive produced by native/gcc8 and extracts it into the base
# toolchain's work tree, next to the stock gcc; the tc_vars generator then picks
# the newest gcc (TC_GCC_SUFFIX in spksrc.toolchain/tc_vars.mk).
#
# DSM 5.2's stock toolchain is doubly stuck: its gcc predates C11/C++17, and the
# 2013-era binary itself aborts on a modern host (loadlocale.c assertion). The
# overlay is a fresh gcc 8.5 build, so it lifts both at once.
TC_ARCH = x64
TC_VERS = 5.2
TC_BASE = syno-$(TC_ARCH)-$(TC_VERS)
TC_TARGET := $(shell grep -E '^TC_TARGET' ../$(TC_BASE)/Makefile 2>/dev/null | sed 's/.*= *//')

PKG_NAME = gcc8-$(TC_ARCH)
PKG_VERS = 8.5.0
PKG_EXT  = txz
# Name/site come from native/gcc8 (print-archive-name).
PKG_DIST_NAME = x64-gcc850_binutils230_glibc217_x86_64-GPL-dsm52-v2.txz
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2Fdsm5.2

EXTRACT_PATH = $(abspath ../$(TC_BASE)/work/$(TC_TARGET))

DEPENDS =
HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GCC 8.5 overlay for the syno-x64-5.2 toolchain (built by native/gcc8).
LICENSE  = GPLv3
INSTALL_TARGET = nop
include ../../mk/spksrc.native-install.mk

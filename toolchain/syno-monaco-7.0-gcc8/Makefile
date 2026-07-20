# GCC 8.5 overlay for syno-monaco-7.0 (consumer, llvm/rust-overlay style). Downloads the
# prebuilt gcc-8.5 archive produced by native/gcc8 and extracts it into the base
# toolchain's work tree, next to the stock gcc; the tc_vars generator then picks
# the newest gcc (TC_GCC_SUFFIX in spksrc.toolchain/tc_vars.mk).
TC_ARCH = monaco
TC_VERS = 7.0
TC_BASE = syno-$(TC_ARCH)-$(TC_VERS)
TC_TARGET := $(shell grep -E '^TC_TARGET' ../$(TC_BASE)/Makefile 2>/dev/null | sed 's/.*= *//')

PKG_NAME = gcc8-$(TC_ARCH)
PKG_VERS = 8.5.0
PKG_EXT  = txz
# Name/site come from native/gcc8 (print-archive-name); a virtual arch reuses the
# canonical arch's archive (monaco), extracted into its own toolchain.
PKG_DIST_NAME = monaco-gcc850_binutils230_glibc226_arm-GPL-dsm70-v2.txz
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2Fdsm7.0

EXTRACT_PATH = $(abspath ../$(TC_BASE)/work/$(TC_TARGET))

DEPENDS =
HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GCC 8.5 overlay for the syno-monaco-7.0 toolchain (built by native/gcc8).
LICENSE  = GPLv3
INSTALL_TARGET = nop
include ../../mk/spksrc.native-install.mk

# Nothing to fix up after extraction: native/gcc8 is built with
# --enable-version-specific-runtime-libs, so gcc-8.5 ships its libstdc++ under
# lib/gcc/<target>/8.5.0/ and resolves it from there. The stock compiler keeps
# resolving the sysroot's own libstdc++, which the overlay never touches -- which
# is exactly what makes LEGACY_TOOLCHAIN=1 mean anything.

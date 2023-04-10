SPK_NAME = synocli-devel
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-devel.png
CHANGELOG = "1. Initial release of synocli-devel"

MAINTAINER = SynoCommunity
DESCRIPTION = SynoCli Development Tools provides a set of command-line utilities for system development and debugging: automake 1.65.5, autoconf 2.71, binutils 2.39$(OPTIONAL_DESC), make 4.4.1, pkg-config 0.29.2.
DISPLAY_NAME = SynoCli Development Tools
STARTABLE = no

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliDevel
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_DEPENDS = "Perl"

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

include ../../mk/spksrc.archs.mk

DEPENDS  = cross/llvm
# build pkg-config before autoconf otherwise
# glib fails on libiconv on some platforms
# (to investigate ...)
DEPENDS += cross/pkg-config
DEPENDS += cross/autoconf
DEPENDS += cross/automake
DEPENDS += cross/binutils
DEPENDS += cross/gdb
DEPENDS += cross/make

##
## autoconf
##
SPK_COMMANDS += bin/autoconf
SPK_COMMANDS += bin/autoheader
SPK_COMMANDS += bin/autom4te
SPK_COMMANDS += bin/autoreconf
SPK_COMMANDS += bin/autoscan
SPK_COMMANDS += bin/autoupdate
SPK_COMMANDS += bin/ifnames
## m4 dependency
SPK_COMMANDS += bin/m4

##
## automake
##
SPK_COMMANDS += bin/aclocal
SPK_COMMANDS += bin/aclocal-1.16
SPK_COMMANDS += bin/automake
SPK_COMMANDS += bin/automake-1.16

##
## binutils
##
SPK_COMMANDS += bin/addr2line
SPK_COMMANDS += bin/ar
SPK_COMMANDS += bin/as
SPK_COMMANDS += bin/c++filt
SPK_COMMANDS += bin/dwp
SPK_COMMANDS += bin/elfedit
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
SPK_COMMANDS += bin/gp-archive
SPK_COMMANDS += bin/gp-collect-app
SPK_COMMANDS += bin/gp-display-html
SPK_COMMANDS += bin/gp-display-src
SPK_COMMANDS += bin/gp-display-text
SPK_COMMANDS += bin/gprofng
endif
SPK_COMMANDS += bin/gprof
SPK_COMMANDS += bin/ld
SPK_COMMANDS += bin/ld.bfd
SPK_COMMANDS += bin/ld.gold
SPK_COMMANDS += bin/nm
SPK_COMMANDS += bin/objcopy
SPK_COMMANDS += bin/objdump
SPK_COMMANDS += bin/ranlib
SPK_COMMANDS += bin/readelf
SPK_COMMANDS += bin/size
SPK_COMMANDS += bin/strings
SPK_COMMANDS += bin/strip

##
## gdb
##

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
OPTIONAL_DESC += ", gdb 7.12.1"
else
OPTIONAL_DESC += ", gdb 13.1"
endif

SPK_COMMANDS += bin/gcore
SPK_COMMANDS += bin/gdb
SPK_COMMANDS += bin/gdb-add-index
SPK_COMMANDS += bin/gdbserver
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
SPK_COMMANDS += bin/run
endif

include ../../mk/spksrc.spk.mk

##
## LLVM
##
ifeq ($(call version_ge, $(TC_GCC), 5.1),1)
OPTIONAL_DESC += ", LLVM 16.0.1"
SPK_COMMANDS += bin/clang-16
else
OPTIONAL_DESC += ", LLVM 9.0.1"
SPK_COMMANDS += bin/clang-9
endif
SPK_COMMANDS += bin/clang
SPK_COMMANDS += bin/clang++
SPK_COMMANDS += bin/clang-check
SPK_COMMANDS += bin/clang-cl
SPK_COMMANDS += bin/clang-cpp
SPK_COMMANDS += bin/clang-extdef-mapping
SPK_COMMANDS += bin/clang-format
SPK_COMMANDS += bin/clang-import-test
SPK_COMMANDS += bin/clang-offload-bundler
SPK_COMMANDS += bin/clang-refactor
SPK_COMMANDS += bin/clang-rename
SPK_COMMANDS += bin/clang-scan-deps
SPK_COMMANDS += bin/git-clang-format
SPK_COMMANDS += bin/hmaptool
SPK_COMMANDS += bin/ld64.lld
SPK_COMMANDS += bin/ld.lld
SPK_COMMANDS += bin/lld
SPK_COMMANDS += bin/lld-link
SPK_COMMANDS += bin/llvm-ar
SPK_COMMANDS += bin/llvm-lib
SPK_COMMANDS += bin/llvm-nm
SPK_COMMANDS += bin/llvm-objcopy
SPK_COMMANDS += bin/llvm-objdump
SPK_COMMANDS += bin/llvm-profdata
SPK_COMMANDS += bin/llvm-ranlib
SPK_COMMANDS += bin/llvm-rc
SPK_COMMANDS += bin/llvm-symbolizer
SPK_COMMANDS += bin/scan-build
SPK_COMMANDS += bin/scan-view
SPK_COMMANDS += bin/wasm-ld

##
## make
##
SPK_COMMANDS += bin/make

##
## pkg-config
##
SPK_COMMANDS += bin/pkg-config

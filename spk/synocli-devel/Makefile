SPK_NAME = synocli-devel
SPK_VERS = 1.3
SPK_REV = 4
SPK_ICON = src/synocli-devel.png
CHANGELOG = "1. Fix autoconf to use installed m4 command.<br/>2. Update autoconf to v2.72.<br/>3. Update binutils to v2.42.<br/>4. Update gdb to v14.2.<br/>5. Update strace to v6.9."

MAINTAINER = SynoCommunity
DESCRIPTION = SynoCli Development Tools provides a set of command-line utilities for system development and debugging: automake 1.65.5, autoconf 2.71, binutils 2.40$(OPTIONAL_DESC), make 4.4.1, pkg-config 0.29.2, libtree 3.1.1, strace 6.5
DISPLAY_NAME = SynoCli Development Tools
STARTABLE = no

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliDevel
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_DEPENDS = "Perl"

OPTIONAL_DEPENDS = cross/llvm

include ../../mk/spksrc.common.mk

ifneq ($(call version_lt, $(TC_GCC), 4.8.1),1)
DEPENDS += cross/llvm
endif

# build binutils bofore the following
# otherwise it fails to build for ARMv5
DEPENDS += cross/binutils
DEPENDS += cross/pkg-config
DEPENDS += cross/gdb
DEPENDS += cross/make
DEPENDS += cross/libtree
DEPENDS += cross/strace

# build autotools last
# otherwise glib and gdb fail on libiconv on some platforms
# (to investigate ...)
DEPENDS += cross/autoconf
DEPENDS += cross/automake

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
ifeq ($(call version_lt, $(TC_GCC), 4.8.1),1)
OPTIONAL_DESC += ", gdb 7.12.1"
else
OPTIONAL_DESC += ", gdb 13.2"
endif
SPK_COMMANDS += bin/gcore
SPK_COMMANDS += bin/gdb
SPK_COMMANDS += bin/gdb-add-index
SPK_COMMANDS += bin/gdbserver
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
SPK_COMMANDS += bin/run
endif

##
## LLVM
##
ifneq ($(call version_lt, $(TC_GCC), 4.8.1),1)
ifeq ($(call version_ge, $(TC_GCC), 5.1),1)
OPTIONAL_DESC += ", LLVM 16.0.6"
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
SPK_COMMANDS += bin/clang-refactor
SPK_COMMANDS += bin/clang-rename
SPK_COMMANDS += bin/clang-scan-deps
SPK_COMMANDS += bin/git-clang-format
SPK_COMMANDS += bin/hmaptool
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
SPK_COMMANDS += bin/llvm-readelf
SPK_COMMANDS += bin/llvm-readobj
SPK_COMMANDS += bin/llvm-size
SPK_COMMANDS += bin/llvm-strings
SPK_COMMANDS += bin/llvm-strip
SPK_COMMANDS += bin/llvm-symbolizer
SPK_COMMANDS += bin/scan-build
SPK_COMMANDS += bin/scan-view
SPK_COMMANDS += bin/wasm-ld
endif

##
## make
##
SPK_COMMANDS += bin/make

##
## pkg-config
##
SPK_COMMANDS += bin/pkg-config

##
## libtree
##
SPK_COMMANDS += bin/libtree

##
## strace
##
SPK_COMMANDS += bin/strace
SPK_COMMANDS += bin/strace-log-merge


include ../../mk/spksrc.spk.mk

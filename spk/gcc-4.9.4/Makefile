SPK_NAME = gcc
SPK_VERS = 4.9.4
SPK_REV  = 1
SPK_ICON = src/gcc.png

DEPENDS = cross/gcc-4.9.4

MAINTAINER = th0ma7
DESCRIPTION = The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, Go, and D, as well as libraries for these languages (libstdc++,...).
RELOAD_UI = no
DISPLAY_NAME = GNU Compiler Collection $(SPK_VERS)
STARTABLE = no
CHANGELOG = "Initial Package including binutils"

HOMEPAGE = https://gcc.gnu.org/
LICENSE = GPLv2

REQUIRE_KERNEL = 1

SPK_COMMANDS  = bin/addr2line bin/ar bin/as bin/c++filt bin/elfedit bin/gprof
SPK_COMMANDS += bin/ld bin/ld.bfd bin/nm bin/objcopy bin/objdump
SPK_COMMANDS += bin/ranlib bin/readelf bin/size bin/strings bin/strip
#SPK_LINKS  = /usr/local/bin/ed2k-link:bin/rhash

include ../../mk/spksrc.spk.mk

###############################################################################
# spksrc.native/toolchain-binutils.mk
#
# Component logic for the host-native binutils cross-build (NATIVE_TOOLCHAIN=binutils).
#
# Builds a clean cross assembler + linker (<target>-as / <target>-ld / ...) for an existing
# Synology toolchain whose stock binutils is too old for modern codegen -- e.g. ppc853x's
# GNU ld 2.18 (2008) segfaults linking Rust cdylibs. 2.30 is the DSM-7.1/7.2 default (matching
# native/gcc8's co-build), new enough for every reloc in play while still targeting DSM-5.2 glibc.
#
# The generic front-end (spksrc.native-toolchain.mk) already provides TC_DIR,
# _tc_get, TC_TARGET and the tc-extract target. This component only resolves the
# sysroot for --with-sysroot; the GNU_CONFIGURE build/install flow is the framework
# default (spksrc.build.mk via native-cc.mk), so there are no target overrides here.
###############################################################################

TC_WORK = $(TC_DIR)/work/$(TC_TARGET)

# crosstool-NG sysroot layouts differ (libc | sys-root | sysroot, sometimes nested). Probe the
# usual spots for the libc headers, take their grandparent. Only a DEFAULT baked into -ld;
# package links come through the gcc driver, which passes an explicit --sysroot anyway.
TC_SYSROOT_DIR = $(patsubst %/usr/include/,%,$(dir $(firstword $(wildcard \
                   $(TC_WORK)/$(TC_TARGET)/libc/usr/include/stdio.h \
                   $(TC_WORK)/$(TC_TARGET)/sys-root/usr/include/stdio.h \
                   $(TC_WORK)/$(TC_TARGET)/sysroot/usr/include/stdio.h \
                   $(TC_WORK)/sys-root/usr/include/stdio.h \
                   $(TC_WORK)/$(TC_TARGET)/usr/include/stdio.h))))

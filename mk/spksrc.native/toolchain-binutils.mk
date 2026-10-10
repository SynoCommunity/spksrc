###############################################################################
# spksrc.native/toolchain-binutils.mk
#
# Component logic for NATIVE_TOOLCHAIN = binutils (spksrc.native-toolchain.mk): a modern
# cross binutils against an EXISTING Synology toolchain's sysroot, published as the archive
# the binutils overlay installs (spksrc.overlay/binutils.mk). The tools land in
# work-<arch>-<vers>/install/usr/local/bin as <target>-{ld,as,ar,...}.
#
#   PKG_NAME = binutils
#   PKG_VERS = 2.30
#   PKG_REV ?= v4
#   NATIVE_TOOLCHAIN = binutils
#   include ../../mk/spksrc.native-toolchain.mk
###############################################################################

GNU_CONFIGURE = 1
# Install the target toolchain first so --with-sysroot resolves.
PRE_CONFIGURE_TARGET = tc-install
CONFIGURE_ARGS  = --target=$(TC_TARGET)
CONFIGURE_ARGS += --program-prefix=$(TC_TARGET)-
CONFIGURE_ARGS += --with-sysroot=$(TC_SYSROOT_DIR)
CONFIGURE_ARGS += --disable-nls --disable-werror --disable-gdb
# The consumers reach for usr/local/bin only. libbfd.a and libopcodes.a are dead weight
# there, and -ffat-lto-objects makes them four times the size of everything else in the
# archive: 7.3 MB and 2.6 MB against 2.3 MB for the whole of x86-5.2's bin/.
CONFIGURE_ARGS += --disable-install-libbfd

# ld and as run in every link of every package: give the host compiler something to work
# with. NATIVE_*FLAGS rather than ENV, which env-default.mk overwrites with them anyway.
NATIVE_CFLAGS   = $(HOST_OPTFLAGS)
NATIVE_CXXFLAGS = $(HOST_OPTFLAGS)
NATIVE_LDFLAGS  = $(HOST_OPTFLAGS)

# The overlay directories this component's consumers carry: all-<vers> builds for them.
TOOLCHAIN_CONSUMER = binutils-$(PKG_VERS)

# as runs once per object, so it is worth profiling the way the compiler is. Measured on
# qoriq-6.2.4 against a non-PGO build made on the same host in the same minute: as 1.27 ->
# 1.14 s over 7.5 MB of assembly (-10.2%), and 1834688 -> 1704880 bytes (-7.1%). ld -r
# moved 2.7%, which is inside the noise.
TOOLCHAIN_PGO       ?= 1
TOOLCHAIN_PGO_TRAIN  = binutils-pgo-train

# Publishable archive. The .txz unpacks usr/local/{bin,...} so an OVERLAY_BINUTILS consumer
# finds <target>-{ld,as,...} under usr/local/bin.
ARCHIVE_NAME = binutils-$(PKG_VERS)-$(TC_TARGET)-$(TOOLCHAIN_DIST_ARCH)-$(TC_VERS)-$(PKG_REV)
# Named after TOOLCHAIN_DIST_ARCH: a generic arch is built as the real arch it shares it with.
TOOLCHAIN_DIST_SHARED = 1
ARCHIVE_EXT  = txz
ARCHIVE_DIR  = $(WORK_DIR)/install
ARCHIVE_KEEP = usr/local

##############################################################################
# PGO training. gcc's harness stops at -S because it profiles cc1; this one starts there:
# the vendor cross gcc emits the assembly, and the INSTRUMENTED as and ld are what consume
# it. -g is deliberate -- DWARF emission is a large part of what as does in a real build,
# and ld -r is the operation the v3 benchmark already measured.
##############################################################################
_PGO_CC   = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-gcc
_PGO_CXX  = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-g++
_PGO_BIN  = $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/$(TC_TARGET)-
# Scratch per arch: three parallel builds writing t-o2.s into one shared directory
# clobbered one another -- an x86 as was handed ARM assembly.
_PGO_WORK = $(WORK_DIR)/pgo-train

.PHONY: binutils-pgo-train
binutils-pgo-train: toolchain-pgo-sources
	@$(MSG) "*** PGO: emitting target assembly with the vendor gcc, then assembling it"
	@# The VENDOR gcc emits the assembly, and it is not one compiler but fifty-six: stock
	@# crosstool-NG on qoriq, a Marvell fork on 88f6281, each talking to ITS assembler.
	@# Two neutralisations, both generic -- no per-arch table:
	@#   1. the -m flags gcc would hand its own as are collected, then each is kept only
	@#      if ours accepts it (--version probe). qoriq keeps -me500 -many -mbig; 88f6281
	@#      loses -mcpu=marvell-f, which upstream binutils has never heard of. Over-
	@#      collecting is harmless precisely because every flag must pass the probe.
	@#   2. the .cpu directive is dropped from the .s, because the vendor writes its own
	@#      CPU name in there too and the flag filter cannot reach it. ONLY .cpu: .fpu and
	@#      .arch carry capabilities the assembler needs -- dropping .fpu cost armada38x
	@#      its VFP and every vldr in the file.
	@# -std is pinned because the vendor gcc spans 4.3.7 to 12.2, and the C++ half is
	@# best-effort: gcc 4.3 has no -std=gnu++11, and training on C alone beats failing.
	@# -fno-var-tracking-assignments when the vendor gcc takes it: the 8.5.0 Synology
	@# ships for DSM 7.1 segfaults on train.c with that pass on, and 4.3 lacks the flag.
	@rm -rf $(_PGO_WORK) && mkdir -p $(_PGO_WORK) && cd $(_PGO_WORK) && \
	  want=$$($(_PGO_CC) -x c /dev/null -c -o /dev/null -### 2>&1 \
	          | tr ' ' '\n' | grep -E '^"?/.*/as"?$$' -A40 | grep -E '^"?-m' | tr -d '"') ; \
	  good="" ; for f in $$want ; do \
	    $(_PGO_BIN)as $$f --version >/dev/null 2>&1 && good="$$good $$f" ; done ; \
	  $(MSG) "*** PGO: as flags kept:$$good" ; \
	  vta="" ; $(_PGO_CC) -fno-var-tracking-assignments -x c /dev/null -S -o /dev/null 2>/dev/null \
	    && vta=-fno-var-tracking-assignments ; \
	  $(_PGO_CC)  --sysroot=$(TC_SYSROOT_DIR) -std=gnu99 -O2 -g $$vta -S -o t-o2.s $(TOOLCHAIN_PGO_SOURCES)/train.c && \
	  $(_PGO_CC)  --sysroot=$(TC_SYSROOT_DIR) -std=gnu99 -O3 -g $$vta -S -o t-o3.s $(TOOLCHAIN_PGO_SOURCES)/train.c && \
	  { $(_PGO_CXX) --sysroot=$(TC_SYSROOT_DIR) -std=gnu++11 -O2 -g $$vta -S -o t-cpp.s $(TOOLCHAIN_PGO_SOURCES)/train.cpp \
	      2>/dev/null || rm -f t-cpp.s ; } ; \
	  for f in *.s ; do \
	    sed -i -E '/^[[:space:]]*\.cpu[[:space:]]/d' $$f ; \
	    $(_PGO_BIN)as $$good $$f -o $${f%.s}.o || exit 1 ; done && \
	  $(_PGO_BIN)ld -r t-o2.o $$(ls t-cpp.o 2>/dev/null) -o t-merged.oo && \
	  $(_PGO_BIN)ld -r t-o3.o -o t-single.oo && \
	  for m in t-merged.oo t-single.oo ; do \
	    $(_PGO_BIN)nm $$m > /dev/null && $(_PGO_BIN)objdump -d $$m > /dev/null || exit 1 ; \
	  done && \
	  rm -rf $(_PGO_WORK)
	@$(MSG) "*** PGO: $$(find $(TOOLCHAIN_PGO_DIR) -name '*.gcda' 2>/dev/null | wc -l) counter files"

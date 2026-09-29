PKG_NAME = binutils
PKG_VERS = 2.30
PKG_EXT  = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# Target toolchain to build a cross-binutils for (per-arch work dir). Defaults to
# ppc853x-5.2, whose stock ld (GNU 2.18.50, 2008) is the one being replaced.
TC_ARCH ?= ppc853x
TC_VERS ?= 5.2

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv3

GNU_CONFIGURE = 1
# Install the target toolchain first so --with-sysroot resolves (tc-install, generic).
PRE_CONFIGURE_TARGET = tc-install
CONFIGURE_ARGS  = --target=$(TC_TARGET)
CONFIGURE_ARGS += --program-prefix=$(TC_TARGET)-
CONFIGURE_ARGS += --with-sysroot=$(TC_SYSROOT_DIR)
CONFIGURE_ARGS += --disable-nls --disable-werror --disable-gdb
# The consumers reach for usr/local/bin only. libbfd.a and libopcodes.a are dead weight
# there, and -ffat-lto-objects makes them four times the size of everything else in the
# archive: 7.3 MB and 2.6 MB against 2.3 MB for the whole of x86-5.2's bin/.
CONFIGURE_ARGS += --disable-install-libbfd

# Publishable archive (release asset / CI download), like native/rustc-1.82. Declared
# BEFORE the native front-end include so the archive helper (via native-cc.mk) sees
# ARCHIVE_NAME; TC_TARGET (=) resolves later. The .txz unpacks usr/local/{bin,...} so an
# OVERLAY_BINUTILS consumer finds <target>-{ld,as,...} under usr/local/bin. Bump the rev
# when a rebuilt archive is re-published under the same (arch,DSM,ver) name.
#
# spksrc.native exports CFLAGS="$(NATIVE_CFLAGS)", and NATIVE_CFLAGS has no default: an
# empty CFLAGS reaches both configure and make, and it overrides the -O2 configure would
# otherwise have chosen. The tools were being built with no optimisation at all. ld and
# as run in every link of every package, so give the host compiler something to work with.
#
# Set through NATIVE_CFLAGS rather than appended to ENV: env-default.mk's own
# `ENV += CFLAGS="$$(NATIVE_CFLAGS)"` is appended when the front-end below is included, so
# an ENV line written here is overridden by the later, empty one -- last assignment wins
# in `env VAR=... cmd`. Filling the variable it reads is order-independent.
#
# Probed, not assumed: -march=x86-64-v3 is a GCC 11 spelling and a host without AVX2 must
# still be able to build this.
_host_cc_ok = $(shell echo 'int main(){return 0;}' | $(or $(CC),cc) $(1) -x c - -o /dev/null 2>/dev/null && echo 1)
HOST_OPTFLAGS  = -O2
HOST_OPTFLAGS += $(if $(call _host_cc_ok,-march=x86-64-v3),-march=x86-64-v3)
HOST_OPTFLAGS += $(if $(call _host_cc_ok,-flto=auto),-flto=auto -ffat-lto-objects)

NATIVE_CFLAGS   = $(HOST_OPTFLAGS)
NATIVE_CXXFLAGS = $(HOST_OPTFLAGS)
NATIVE_LDFLAGS  = $(HOST_OPTFLAGS)

# as runs once per object, so it is worth profiling the way the compiler is. Same two-pass
# shape as native/gcc-8.5: instrument, run the instrumented tools over real target assembly,
# rebuild reading the counts. Measured on qoriq-6.2.4 against a non-PGO build made on the
# same host in the same minute: as 1.27 -> 1.14 s over 7.5 MB of assembly (-10.2%), and
# 1834688 -> 1704880 bytes (-7.1%). ld -r moved 2.7%, which is inside the noise.
BINUTILS_PGO     ?= 1
BINUTILS_PGO_DIR  = $(CURDIR)/work-$(TC_ARCH)-$(TC_VERS)-profile
BINUTILS_PGO_GEN  = -fprofile-generate=$(BINUTILS_PGO_DIR) -fprofile-update=atomic
# Same reason as gcc's: coverage-mismatch is an error by default and configure compiles a
# succession of different conftest.c, so every configure in the tree would fail to find a
# working compiler.
BINUTILS_PGO_USE  = -fprofile-use=$(BINUTILS_PGO_DIR) -fprofile-correction \
                    -Wno-missing-profile -Wno-error=coverage-mismatch -Wno-coverage-mismatch

# PGO_PHASE is set by the arch-% recipe; a plain `make all` stays a single ordinary pass.
HOST_OPTFLAGS += $(if $(filter gen,$(PGO_PHASE)),$(BINUTILS_PGO_GEN))
HOST_OPTFLAGS += $(if $(filter use,$(PGO_PHASE)),$(BINUTILS_PGO_USE))

# v3: same binutils, rebuilt with the flags above actually reaching the compiler.
# v4: same again, profile-guided. Every consumer pins the same rev.
PKG_REV ?= v4
# The consumer fetches by PKG_DIST_ARCH, which is not always TC_ARCH: aarch64 takes
# rtd1296, armv7 armada38x, x64 x86 or apollolake. Read back from the consumer rather
# than tabulated here, so the name this produces cannot drift from the name fetched.
TC_DIST_ARCH = $(or $(strip $(shell sed -n 's/^PKG_DIST_ARCH[[:space:]]*=[[:space:]]*//p' \
                 ../../toolchain/syno-$(TC_ARCH)-$(TC_VERS)_binutils-$(PKG_VERS)/Makefile \
                 2>/dev/null | sed 's|$$(TC_ARCH)|$(TC_ARCH)|')),$(TC_ARCH))
ARCHIVE_NAME = binutils-$(PKG_VERS)-$(TC_TARGET)-$(TC_DIST_ARCH)-$(TC_VERS)-$(PKG_REV)
ARCHIVE_EXT  = txz
ARCHIVE_DIR  = $(WORK_DIR)/install
ARCHIVE_KEEP = usr/local

# Generic native-toolchain front-end dispatches to mk/spksrc.native/toolchain-binutils.mk.
NATIVE_TOOLCHAIN = binutils
include ../../mk/spksrc.native-toolchain.mk

##############################################################################
# Build (and archive) binutils for a SPECIFIC toolchain of a given DSM version.
#   make arch-ppc853x-5.2      make arch-qoriq-6.2.4
# The co-built tools land in work-<arch>-<vers>/install/usr/local/bin as
# <target>-{ld,as,ar,...}; OVERLAY_BINUTILS consumers point at that bin dir. The
# archive step publishes the same tree as a .txz for the release / CI download.
##############################################################################
.PHONY: arch-%
arch-%:
	@$(MSG) "===== binutils-$(PKG_VERS): $* ====="
ifeq ($(strip $(BINUTILS_PGO)),1)
	@$(MSG) "===== binutils-$(PKG_VERS): $* -- PGO pass 1/2 (instrumented) ====="
	@rm -rf work-$* work-$*-profile
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) PGO_PHASE=gen all
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) PGO_PHASE=gen binutils-pgo-train
	@$(MSG) "===== binutils-$(PKG_VERS): $* -- PGO pass 2/2 (optimised) ====="
	@rm -rf work-$*
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) PGO_PHASE=use all
	@rm -rf work-$*-profile
else
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) all
endif
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) build-archive

##############################################################################
# PGO training. gcc's harness stops at -S because it profiles cc1; this one starts
# there: the vendor cross gcc emits the assembly, and the INSTRUMENTED as and ld are
# what consume it. -g is deliberate -- DWARF emission is a large part of what as does
# in a real build, and ld -r is the operation the v3 benchmark already measured.
##############################################################################
_PGO_CC   = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-gcc
_PGO_CXX  = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-g++
_PGO_BIN  = $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/$(TC_TARGET)-
# Scratch per arch: pgo/ holds the sources and is SHARED, so three parallel builds
# writing t-o2.s into it clobbered one another -- an x86 as was handed ARM assembly.
_PGO_WORK = $(WORK_DIR)/pgo-train

.PHONY: binutils-pgo-train
binutils-pgo-train:
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
	  $(_PGO_CC)  --sysroot=$(TC_SYSROOT_DIR) -std=gnu99 -O2 -g $$vta -S -o t-o2.s $(CURDIR)/pgo/train.c && \
	  $(_PGO_CC)  --sysroot=$(TC_SYSROOT_DIR) -std=gnu99 -O3 -g $$vta -S -o t-o3.s $(CURDIR)/pgo/train.c && \
	  { $(_PGO_CXX) --sysroot=$(TC_SYSROOT_DIR) -std=gnu++11 -O2 -g $$vta -S -o t-cpp.s $(CURDIR)/pgo/train.cpp \
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
	@$(MSG) "*** PGO: $$(find $(BINUTILS_PGO_DIR) -name '*.gcda' 2>/dev/null | wc -l) counter files"

##############################################################################
# Build (and archive) binutils for EVERY toolchain of a given DSM version.
#
#   make all-6.2.4                 one arch at a time
#   make BINUTILS_JOBS=5 all-6.2.4     5 archs at a time (each still max threads)
#
# The consumers ARE the arch list -- one consumer, one archive, so there is no table
# here and no virtual/canonical special case.
#
# Concurrency via xargs -P, deliberately NOT make's -j: -j goes into MAKEFLAGS and
# propagates into every sub-make, parallelising toolchain targets not written for it.
##############################################################################
BINUTILS_ARCHS = $(shell ls -d ../../toolchain/syno-*-$(1)_binutils-2.30 2>/dev/null | \
                    sed 's|.*/syno-||; s|-$(1)_binutils-2.30$$||')
BINUTILS_JOBS ?= 1

.PHONY: all-%
all-%:
	@$(MSG) "===== binutils-$(PKG_VERS): all-$* -- $(words $(call BINUTILS_ARCHS,$*)) archs, $(BINUTILS_JOBS) at a time ====="
	@echo "$(sort $(call BINUTILS_ARCHS,$*))" | tr ' ' '\n' | \
	   xargs -P $(BINUTILS_JOBS) -I@ $(MAKE) --no-print-directory arch-@-$*
	@$(MSG) "===== binutils-$(PKG_VERS): all-$* complete ====="

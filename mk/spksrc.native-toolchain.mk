###############################################################################
# spksrc.native-toolchain.mk
#
# Shared logic for host-native packages that (re)build a cross toolchain
# component (binutils, gcc, ...) against an EXISTING Synology toolchain's
# sysroot. Parametrized by (TC_ARCH, TC_VERS); each target gets its own work
# dir  work-<arch>-<tcversion>  (like cross packages), so every (arch, DSM) is
# visible and independent.
#
#   make TC_ARCH=x64        TC_VERS=6.2.4
#   make TC_ARCH=comcerto2k TC_VERS=7.1
#
# Provides (for the including package's CONFIGURE_ARGS):
#   TC_TARGET      target triple (read from the toolchain Makefile)
#   TC_SYSROOT_DIR the toolchain sysroot (glibc + headers)
#   TC_BINUTILS_BIN bin dir of the binutils gcc must use (reuse|co-built)
#   TC_BINUTILS    binutils version recorded in the archive name (e.g. 2.30)
#   GCC8_TARGET_ABI  arch ABI flags, GCC-8.5-sanitized (gcc only)
#   TC_EXTRA_CFLAGS  reused verbatim from the toolchain (dynamic, not repeated)
#
# The include of spksrc.native-cc.mk is done here; WORK_DIR is pre-set so the
# native default (-native) is not used.
###############################################################################

ifeq ($(strip $(TC_ARCH)),)
$(error spksrc.native-toolchain.mk: TC_ARCH is required (e.g. TC_ARCH=x64))
endif
ifeq ($(strip $(TC_VERS)),)
$(error spksrc.native-toolchain.mk: TC_VERS is required (e.g. TC_VERS=6.2.4))
endif

TC          = syno-$(TC_ARCH)-$(TC_VERS)
TC_DIR      = $(abspath $(CURDIR)/../../toolchain/$(TC))
TC_TARGET  := $(shell grep -E '^TC_TARGET' $(TC_DIR)/Makefile 2>/dev/null | sed 's/.*= *//')
TC_WORK     = $(TC_DIR)/work/$(TC_TARGET)

# Per-(arch,dsm) work dir, cross-style; pre-set so native-cc.mk keeps it.
WORK_DIR    = $(CURDIR)/work-$(TC_ARCH)-$(TC_VERS)
INSTALL_PREFIX = /usr/local

# Sysroot: crosstool-NG layouts differ (sys-root | sysroot | libc).
TC_SYSROOT_DIR = $(patsubst %/usr/include/,%,$(dir $(firstword $(wildcard \
                   $(TC_WORK)/$(TC_TARGET)/sys-root/usr/include/stdio.h \
                   $(TC_WORK)/$(TC_TARGET)/sysroot/usr/include/stdio.h \
                   $(TC_WORK)/$(TC_TARGET)/libc/usr/include/stdio.h))))

# Reuse whatever compile flags the toolchain already declares (qoriq SPE, ...),
# instead of repeating them here.
TC_EXTRA_CFLAGS := $(shell grep -E '^TC_EXTRA_CFLAGS' $(TC_DIR)/Makefile 2>/dev/null | sed 's/.*= *//')

# ---- binutils policy ---------------------------------------------------------
# binutils version co-built for / expected from the toolchain. 2.30 is the
# DSM-7.1/7.2 default -- matching it is the whole point. Change it here only:
# everything below (the native/binutils-<vers> package, the archive name) derives
# from BINUTILS_VERS.
BINUTILS_VERS = 2.30
BINUTILS_DIR  = $(abspath $(CURDIR)/../binutils-$(BINUTILS_VERS))
# Recorded in the gcc-8.5 archive name, like TC_GLIBC / TC_VERS.
TC_BINUTILS   = $(BINUTILS_VERS)

# Co-build a clean binutils whenever the toolchain's stock binutils is too old to
# link what gcc-8.5 emits, and reuse it otherwise. The cutoff is glibc <= 2.20,
# which is exactly DSM <= 6.2.4 (plus the comcerto2k orphan): those toolchains
# ship binutils <= 2.25, and gcc-8.5 emits relocations they cannot handle -- the
# ARM/PPC vendor forks reject a full gcc-8.5 invocation (-march=armv7-a+mp+sec,
# -me500), and even the x86 Linaro 2.25 ld fails on R_X86_64_GOTPCRELX (0x2a,
# added in binutils 2.26), e.g. linking the static libstdc++fs.a for
# std::filesystem. DSM 7.0+ already ship a new-enough binutils, so they reuse. A
# newer binutils targeting an older glibc is fine; the constraint only runs the
# other way (a binutils must be new enough for its glibc/compiler). Lazy (=) so
# version_le (macros.mk, included below) resolves at expansion time.
TC_GLIBC     := $(shell grep -E '^TC_GLIBC' $(TC_DIR)/Makefile 2>/dev/null | sed 's/.*= *//')
BINUTILS_MODE = $(if $(call version_le,$(TC_GLIBC),2.20),cobuild,reuse)
# bin dir gcc must use: the toolchain's own (reuse) or the co-built one (cobuild,
# installed by native/binutils-<vers>). Lazy $(if ...) — NOT an ifeq — so
# BINUTILS_MODE resolves at expansion time (version_le is only available once
# macros.mk is included below); a parse-time ifeq would wrongly read "reuse".
TC_BINUTILS_BIN_REUSE   = $(TC_WORK)/bin
TC_BINUTILS_BIN_COBUILD = $(BINUTILS_DIR)/work-$(TC_ARCH)-$(TC_VERS)/install/usr/local/bin
TC_BINUTILS_BIN = $(if $(filter reuse,$(BINUTILS_MODE)),$(TC_BINUTILS_BIN_REUSE),$(TC_BINUTILS_BIN_COBUILD))

# The target toolchain must be extracted before its sysroot exists: native
# packages do not bootstrap the toolchain the way cross packages do (cross-stage1).
# TC_SYSROOT_DIR is a recursively-expanded (=) wildcard, so once this target has
# run the sysroot resolves at configure/build time. Idempotent; include it as a
# PRE_CONFIGURE_TARGET prerequisite in the consuming package.
.PHONY: tc-extract
tc-extract:
	@$(MSG) "native-toolchain: ensuring $(TC) is extracted (sysroot for $(TC_ARCH)-$(TC_VERS))"
	@$(MAKE) --no-print-directory -C ../../toolchain/$(TC) toolchain

# ---- per-arch ABI (GCC 8.5): derived dynamically from the toolchain's own
# stock gcc + modern-GCC fixups. Pure make, no table maintained anywhere, no
# toolchain Makefile edits. Provides GCC8_TARGET_ABI (uses TC_WORK/TC_TARGET).
include ../../mk/spksrc.toolchain/gcc-abi.mk

include ../../mk/spksrc.native-cc.mk

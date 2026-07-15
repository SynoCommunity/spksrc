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
#   TC_BINUTILS    bin dir of the binutils gcc must use (reuse|co-built)
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
# Reuse the toolchain's own binutils (it matches its glibc) EXCEPT for the old
# broken vendor forks (DSM-6.2.4 ARM/PPC + comcerto2k, all glibc <= 2.20) which
# gcc-8.5 cannot drive; those co-build a clean binutils 2.30 -- the DSM-7.1/7.2
# default -- so the rebuilt toolchains stay aligned with the Synology standard.
# A newer binutils targeting an older glibc is fine (the constraint runs the
# other way: a binutils must be new enough for its glibc, e.g. glibc 2.26 needs
# >= 2.26).
# Derived: co-build only for ARM/PPC toolchains whose glibc <= 2.20 (their stock
# binutils are old vendor forks gcc-8.5 cannot drive). x86 (any DSM) and every
# glibc >= 2.21 toolchain (DSM 7.0+ already ship binutils 2.30) reuse. Lazy (=)
# so version_le (from macros.mk, included below) is available at expansion time.
TC_GLIBC     := $(shell grep -E '^TC_GLIBC' $(TC_DIR)/Makefile 2>/dev/null | sed 's/.*= *//')
TC_IS_ARMPPC := $(shell echo $(TC_TARGET) | grep -ciE 'arm|aarch64|powerpc')
BINUTILS_MODE = $(if $(filter-out 0,$(TC_IS_ARMPPC)),$(if $(call version_le,$(TC_GLIBC),2.20),cobuild,reuse),reuse)
# bin dir gcc must use: the toolchain's own (reuse) or the co-built 2.30
# (cobuild, installed by native/binutils-2.30). Lazy $(if ...) — NOT an ifeq —
# so BINUTILS_MODE resolves at expansion time (version_le is only available once
# macros.mk is included below); a parse-time ifeq would wrongly read "reuse".
TC_BINUTILS_REUSE   = $(TC_WORK)/bin
TC_BINUTILS_COBUILD = $(abspath $(CURDIR)/../binutils-2.30/work-$(TC_ARCH)-$(TC_VERS)/install/usr/local/bin)
TC_BINUTILS = $(if $(filter reuse,$(BINUTILS_MODE)),$(TC_BINUTILS_REUSE),$(TC_BINUTILS_COBUILD))

# ---- per-arch ABI (GCC 8.5): derived dynamically from the toolchain's own
# stock gcc + modern-GCC fixups. Pure make, no table maintained anywhere, no
# toolchain Makefile edits. Provides GCC8_TARGET_ABI (uses TC_WORK/TC_TARGET).
include ../../mk/spksrc.toolchain/gcc-abi.mk

include ../../mk/spksrc.native-cc.mk

###############################################################################
# spksrc.common/tc-capability.mk
#
# Lets a package declare what it NEEDS from a toolchain instead of enumerating
# the architectures where it happens to fail today:
#
#   MIN_GLIBC_VERSION  = 2.20   needs glibc 2.20 or newer
#   MIN_KERNEL_VERSION = 3.10   needs a 3.10 or newer kernel
#   MIN_GCC_VERSION    = 8      needs gcc 8 or newer
#   MIN_BINUTILS_VERSION = 2.20 needs binutils 2.20 or newer (as/ld)
#   MIN_RUSTC_VERSION  = 1.85   needs rustc 1.85 or newer
#   REQUIRE_64BIT      = 1      needs a 64-bit target
#
# A floor REFUSES the arch. Where a package must instead CHOOSE between versions of
# itself -- the cross/<pkg> virtuals -- compare TC_GCC / TC_GLIBC / TC_KERNEL / TC_RUSTC
# with version_ge directly.
#
# This replaces "UNSUPPORTED_ARCHS = <list>" for capability reasons. A hardcoded
# list says WHERE a package fails, not WHY; it has to be rechecked by hand every
# time a toolchain moves, and it cannot express "any arch whose gcc is older than
# X". A declared floor can, and it stays correct on its own.
#
# Resolved statically from the toolchain's own Makefile -- TC_GCC, TC_GLIBC and
# TC_KERNEL, each declared there beside TC_DIST -- so the answer never depends on
# how the toolchain was last built.
#
# A failing check sets TC_CAPABILITY_UNSUPPORTED to a human sentence; pre-check.mk
# turns that into the arch-refusal error, next to UNSUPPORTED_ARCHS.
###############################################################################

# Does this toolchain's gcc ship libatomic? Ask it -- a gcc too old to have it also predates
# __atomic_* and never needs it. Lazy (=), outside the ARCH guard: it runs the cross gcc.
TC_HAS_LIBATOMIC = $(if $(filter /%,$(shell $(TC_WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc -print-file-name=libatomic.so 2>/dev/null)),1)

# Outside the guard on purpose: the native producers read TC_HAS_LIBATOMIC with no ARCH.
ifneq ($(strip $(ARCH))$(strip $(TCVERSION)),)

_TC_CAP_MK := $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/Makefile

# The toolchain's own gcc / glibc / kernel, read from where it declares them --
# statically, so a package can gate on any of them before anything is built (the
# kernel one, for instance, for an API that appeared in a given release).
TC_GCC      := $(shell sed -n 's/^TC_GCC *= *//p'      $(_TC_CAP_MK) 2>/dev/null)
TC_GLIBC    := $(shell sed -n 's/^TC_GLIBC *= *//p'    $(_TC_CAP_MK) 2>/dev/null)
TC_KERNEL   := $(shell sed -n 's/^TC_KERNEL *= *//p'   $(_TC_CAP_MK) 2>/dev/null)
TC_BINUTILS := $(shell sed -n 's/^TC_BINUTILS *= *//p' $(_TC_CAP_MK) 2>/dev/null)

# Reasons accumulate rather than overwrite: an arch can miss more than one
# capability at once -- a 32-bit target on an old gcc fails REQUIRE_64BIT and
# MIN_GCC_VERSION together -- and reporting only the last is misleading. They are
# joined by comma_append (spksrc.common/macros.mk); the messages carry no comma of their
# own, which a $(call) argument would split on.
#
# Reset first: this file is included more than once per build (via spksrc.common.mk),
# and appending is not idempotent the way the old overwrite was -- without this the
# same reasons would pile up on every re-parse.
TC_CAPABILITY_UNSUPPORTED :=

# ---- glibc: a runtime floor, so too old means genuinely unsupported ---------
# Linking against a newer glibc than the NAS runs produces binaries that will not
# start, so nothing can lift this.
ifneq ($(strip $(MIN_GLIBC_VERSION)),)
ifneq ($(strip $(TC_GLIBC)),)
ifeq ($(call version_ge,$(TC_GLIBC),$(MIN_GLIBC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(call comma_append,$(TC_CAPABILITY_UNSUPPORTED),glibc $(TC_GLIBC) < $(MIN_GLIBC_VERSION) (a runtime floor: no toolchain can lift it))
endif
endif
endif

# ---- kernel: a runtime floor like glibc -------------------------------------
# A driver stack talks to ioctls the running kernel either has or has not. No compiler
# can supply one, so this refuses the arch outright rather than letting it build.
ifneq ($(strip $(MIN_KERNEL_VERSION)),)
ifneq ($(strip $(TC_KERNEL)),)
ifeq ($(call version_ge,$(TC_KERNEL),$(MIN_KERNEL_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(call comma_append,$(TC_CAPABILITY_UNSUPPORTED),kernel $(TC_KERNEL) < $(MIN_KERNEL_VERSION) (a runtime floor: no toolchain can lift it))
endif
endif
endif

# ---- gcc: the compiler the toolchain ships ----------------------------------
# Plain ifeq rather than a nested $(if): version_ge returns empty for false.
ifneq ($(strip $(MIN_GCC_VERSION)),)
ifneq ($(strip $(TC_GCC)),)
ifeq ($(call version_ge,$(TC_GCC),$(MIN_GCC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(call comma_append,$(TC_CAPABILITY_UNSUPPORTED),gcc $(TC_GCC) < $(MIN_GCC_VERSION))
endif
endif
endif

# ---- binutils: the assembler and linker the toolchain ships ------------------
# A build-time floor like gcc, not a runtime one: it asks what as/ld can encode and
# resolve, and a newer binutils answers it. The vendor toolchains span 2.18.50 (2008) to
# 2.38, so an object a current compiler emits can carry a relocation or a debug format
# the shipped linker never learned -- which is a property of the linker, not of the
# architecture it happens to target.
ifneq ($(strip $(MIN_BINUTILS_VERSION)),)
ifneq ($(strip $(TC_BINUTILS)),)
ifeq ($(call version_ge,$(TC_BINUTILS),$(MIN_BINUTILS_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(call comma_append,$(TC_CAPABILITY_UNSUPPORTED),binutils $(TC_BINUTILS) < $(MIN_BINUTILS_VERSION))
endif
endif
endif

# ---- rustc: the rust version the toolchain pins -----------------------------
# Custom-rust archs (qoriq/ppc853x/88f6281/x86-5.2) are pinned to the rust version their
# overlay ships (1.82.0, the last supporting their old glibc), read from the rust consumer's
# PKG_VERS; a toolchain still pinning TC_RUSTC itself is honored too.
_TC_CAP_RUST_MK := $(firstword $(wildcard $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)_rust-*/Makefile))
ifneq ($(strip $(_TC_CAP_RUST_MK)),)
_TC_CAP_RUSTC := $(shell sed -n 's/^PKG_VERS *= *//p' $(_TC_CAP_RUST_MK) 2>/dev/null)
else
_TC_CAP_RUSTC := $(shell sed -n 's/^TC_RUSTC *= *//p' $(_TC_CAP_MK) 2>/dev/null)
endif

# Published beside TC_GCC/TC_GLIBC/TC_KERNEL, and never empty: only an ACTIVE overlay pins a
# version, otherwise the arch really does build on rustup 'stable' -- which sorts above every
# number, so it clears any floor without a network query.
# ?=, so spksrc.toolchain.mk keeps the last word inside a toolchain dir.
TC_RUSTC ?= $(if $(OVERLAY_RUSTC_ON),$(_TC_CAP_RUSTC),stable)

ifneq ($(strip $(MIN_RUSTC_VERSION)),)
ifeq ($(call version_ge,$(TC_RUSTC),$(MIN_RUSTC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(call comma_append,$(TC_CAPABILITY_UNSUPPORTED),rustc $(TC_RUSTC) < $(MIN_RUSTC_VERSION))
endif
endif

# ---- 64-bit: an ISA fact the toolchain cannot change ------------------------
# A package that declares REQUIRE_64BIT = 1 cannot run on a 32-bit arch, whatever
# the compiler -- so it is a capability like the two floors above, and lands in the
# same TC_CAPABILITY_UNSUPPORTED. Guarded on a non-empty ARCH: an empty ARCH is not
# in $(64bit_ARCHS) either, and the arch-less passes (the source download) must not
# trip on it.
ifeq ($(strip $(REQUIRE_64BIT)),1)
ifneq ($(strip $(ARCH)),)
ifeq (,$(findstring $(ARCH),$(64bit_ARCHS)))
TC_CAPABILITY_UNSUPPORTED := $(call comma_append,$(TC_CAPABILITY_UNSUPPORTED),requires a 64-bit architecture)
endif
endif
endif

endif # ifneq ARCH/TCVERSION

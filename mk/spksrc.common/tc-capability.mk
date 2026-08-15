###############################################################################
# spksrc.common/tc-capability.mk
#
# Lets a package declare what it NEEDS from a toolchain instead of enumerating
# the architectures where it happens to fail today:
#
#   MIN_GLIBC_VERSION = 2.20    needs glibc 2.20 or newer
#   MIN_GCC_VERSION   = 8       needs gcc 8 or newer
#   MIN_RUSTC_VERSION = 1.85    needs rustc 1.85 or newer
#   REQUIRE_64BIT     = 1       needs a 64-bit target
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

# Does this toolchain's gcc ship libatomic? Ask it, rather than tabulate.
#
# A target without native 64-bit atomics (ARMv5, PowerPC e500v2) makes gcc emit calls into
# libatomic, which the link then has to resolve. But the library only ships from gcc 4.7 on,
# and handing -latomic to an older gcc is fatal ("cannot find -latomic"). Availability is the
# exact criterion, not a proxy: a gcc old enough to lack libatomic also predates the __atomic_*
# builtins, emits __sync_* instead, and so never needs the library. One question answers both.
#
# Lazy (=), unlike the static reads below: it RUNS the cross gcc, which does not exist yet
# while the toolchain is still being bootstrapped. Outside the ARCH guard, and keyed on
# TC_* only, so the native producers (spksrc.native/toolchain-rust.mk) reach it too.
TC_HAS_LIBATOMIC = $(if $(filter /%,$(shell $(TC_WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc -print-file-name=libatomic.so 2>/dev/null)),1)

ifneq ($(strip $(ARCH))$(strip $(TCVERSION)),)

_TC_CAP_MK := $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/Makefile

# The toolchain's own gcc / glibc / kernel, read from where it declares them --
# statically, so a package can gate on any of them before anything is built (the
# kernel one, for instance, for an API that appeared in a given release).
TC_GCC    := $(shell sed -n 's/^TC_GCC *= *//p'    $(_TC_CAP_MK) 2>/dev/null)
TC_GLIBC  := $(shell sed -n 's/^TC_GLIBC *= *//p'  $(_TC_CAP_MK) 2>/dev/null)
TC_KERNEL := $(shell sed -n 's/^TC_KERNEL *= *//p' $(_TC_CAP_MK) 2>/dev/null)

# Reasons accumulate rather than overwrite: an arch can miss more than one
# capability at once -- a 32-bit target on an old gcc fails REQUIRE_64BIT and
# MIN_GCC_VERSION together -- and reporting only the last is misleading. They are
# joined with ", "; the messages carry no comma of their own. _tc_cap_comma exists
# because a bare comma is an argument separator inside the $(if) that adds the
# separator only from the second reason on.
#
# Reset first: this file is included more than once per build (via spksrc.common.mk),
# and appending is not idempotent the way the old overwrite was -- without this the
# same reasons would pile up on every re-parse.
TC_CAPABILITY_UNSUPPORTED :=
_tc_cap_comma := ,
_tc_cap_join    = $(if $(strip $(TC_CAPABILITY_UNSUPPORTED)),$(_tc_cap_comma) )

# ---- glibc: a runtime floor, so too old means genuinely unsupported ---------
# Linking against a newer glibc than the NAS runs produces binaries that will not
# start, so nothing can lift this.
ifneq ($(strip $(MIN_GLIBC_VERSION)),)
ifneq ($(strip $(TC_GLIBC)),)
ifeq ($(call version_ge,$(TC_GLIBC),$(MIN_GLIBC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(TC_CAPABILITY_UNSUPPORTED)$(_tc_cap_join)glibc $(TC_GLIBC) < $(MIN_GLIBC_VERSION) (a runtime floor: no toolchain can lift it)
endif
endif
endif

# ---- gcc: the compiler the toolchain ships ----------------------------------
# Plain ifeq rather than a nested $(if): version_ge returns empty for false.
ifneq ($(strip $(MIN_GCC_VERSION)),)
ifneq ($(strip $(TC_GCC)),)
ifeq ($(call version_ge,$(TC_GCC),$(MIN_GCC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(TC_CAPABILITY_UNSUPPORTED)$(_tc_cap_join)gcc $(TC_GCC) < $(MIN_GCC_VERSION)
endif
endif
endif

# ---- rustc: the rust version the toolchain pins -----------------------------
# Custom-rust archs (qoriq/ppc853x/88f6281/x86-5.2) are pinned to the rust version their
# overlay ships (e.g. 1.82.0, the last supporting their old glibc), so a package needing a
# newer rustc is genuinely unsupported there. The version is the rust consumer's PKG_VERS
# (same source of truth as TC_RUSTC in spksrc.toolchain.mk); a toolchain still pinning
# TC_RUSTC itself is honored too. Standard archs have neither (rustup 'stable' = newest), so
# an empty/'stable' value satisfies any floor -- only a pinned concrete version is compared,
# no network query. A local var, so env-rust.mk's TC_RUSTC 'stable' default is untouched.
_TC_CAP_RUST_MK := $(firstword $(wildcard $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)-rust-*/Makefile))
ifneq ($(strip $(_TC_CAP_RUST_MK)),)
_TC_CAP_RUSTC := $(shell sed -n 's/^PKG_VERS *= *//p' $(_TC_CAP_RUST_MK) 2>/dev/null)
else
_TC_CAP_RUSTC := $(shell sed -n 's/^TC_RUSTC *= *//p' $(_TC_CAP_MK) 2>/dev/null)
endif
ifneq ($(strip $(MIN_RUSTC_VERSION)),)
ifneq ($(strip $(_TC_CAP_RUSTC)),)
ifneq ($(strip $(_TC_CAP_RUSTC)),stable)
ifeq ($(call version_ge,$(_TC_CAP_RUSTC),$(MIN_RUSTC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(TC_CAPABILITY_UNSUPPORTED)$(_tc_cap_join)rustc $(_TC_CAP_RUSTC) < $(MIN_RUSTC_VERSION)
endif
endif
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
TC_CAPABILITY_UNSUPPORTED := $(TC_CAPABILITY_UNSUPPORTED)$(_tc_cap_join)requires a 64-bit architecture
endif
endif
endif

endif # ifneq ARCH/TCVERSION

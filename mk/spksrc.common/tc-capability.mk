###############################################################################
# spksrc.common/tc-capability.mk
#
# Lets a package declare what it NEEDS from a toolchain instead of enumerating
# the architectures where it happens to fail today:
#
#   MIN_GLIBC_VERSION = 2.20    needs glibc 2.20 or newer
#   MIN_GCC_VERSION   = 8       needs gcc 8 or newer
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

ifneq ($(strip $(ARCH))$(strip $(TCVERSION)),)

_TC_CAP_MK := $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/Makefile

# The toolchain's own gcc / glibc / kernel, read from where it declares them --
# statically, so a package can gate on any of them before anything is built (the
# kernel one, for instance, for an API that appeared in a given release).
TC_GCC    := $(shell sed -n 's/^TC_GCC *= *//p'    $(_TC_CAP_MK) 2>/dev/null)
TC_GLIBC  := $(shell sed -n 's/^TC_GLIBC *= *//p'  $(_TC_CAP_MK) 2>/dev/null)
TC_KERNEL := $(shell sed -n 's/^TC_KERNEL *= *//p' $(_TC_CAP_MK) 2>/dev/null)

# ---- gcc overlay selection --------------------------------------------------
# A gcc overlay (toolchain/syno-<arch>-<vers>-gcc8) installs a newer gcc beside the
# stock one, reusing the same sysroot. TC_OVERLAY_GCC is the gcc it can provide
# (empty when no overlay exists here); TC_GCC (above) stays the stock gcc.
TC_OVERLAY_GCC := $(if $(wildcard $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)-gcc8),8.5)
# Was LEGACY_TOOLCHAIN set on purpose (command line / Makefile) rather than defaulted?
_TC_LEGACY_EXPLICIT := $(if $(filter undefined default,$(origin LEGACY_TOOLCHAIN)),,1)

# Step 1 -- pick the compiler. If the stock gcc is too old for MIN_GCC_VERSION but
# an overlay would satisfy it, and nobody forced the stock, select the overlay:
# picking a toolchain that meets a stated requirement is the framework's job, not
# the package's. An explicit LEGACY_TOOLCHAIN is left untouched here and wins.
ifneq ($(strip $(MIN_GCC_VERSION)),)
ifneq ($(strip $(TC_GCC)),)
ifeq ($(call version_ge,$(TC_GCC),$(MIN_GCC_VERSION)),)
ifneq ($(call version_ge,$(TC_OVERLAY_GCC),$(MIN_GCC_VERSION)),)
ifeq ($(_TC_LEGACY_EXPLICIT),)
LEGACY_TOOLCHAIN := 0
endif
endif
endif
endif
endif
# Default: stock gcc, so an installed overlay stays inactive unless step 1 lifted it.
LEGACY_TOOLCHAIN ?= 1

# The gcc this build will actually use: the stock one when legacy, else the pin
# (TC_GCC_VERSION) or the overlay, falling back to stock.
TC_GCC_EFFECTIVE := $(if $(filter 1 on ON,$(strip $(LEGACY_TOOLCHAIN))),$(TC_GCC),$(or $(strip $(TC_GCC_VERSION)),$(TC_OVERLAY_GCC),$(TC_GCC)))

# Whether TC_GCC_EFFECTIVE comes from a gcc overlay rather than the toolchain's
# stock gcc -- the mode (overlay|legacy), known statically here. TC_GCC_SUFFIX in
# tc_vars only exists once the work dir's tc_vars.mk has been generated, so anything
# that runs during the dependency walk (the build status line) cannot read it and
# must use this instead. Overlay is active when the build is not forced legacy and
# an overlay gcc is actually available to select.
TC_GCC_IS_OVERLAY := $(if $(filter 1 on ON,$(strip $(LEGACY_TOOLCHAIN))),,$(if $(or $(strip $(TC_GCC_VERSION)),$(strip $(TC_OVERLAY_GCC))),1))

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

# ---- gcc: judged against the compiler actually selected ---------------------
# Step 2 -- judge TC_GCC_EFFECTIVE, not the stock gcc. An overlay can lift the
# floor, but only when it was really picked: a forced LEGACY_TOOLCHAIN=1 or a
# too-low TC_GCC_VERSION compiles with the stock gcc anyway, and checking "could an
# overlay satisfy this?" would wave that build through to fail deep in a source
# file later. Each cause names itself. Plain ifeq rather than a nested $(if):
# version_ge returns empty for false.
ifneq ($(strip $(MIN_GCC_VERSION)),)
ifneq ($(strip $(TC_GCC_EFFECTIVE)),)
ifeq ($(call version_ge,$(TC_GCC_EFFECTIVE),$(MIN_GCC_VERSION)),)
ifneq ($(call version_ge,$(TC_OVERLAY_GCC),$(MIN_GCC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := $(TC_CAPABILITY_UNSUPPORTED)$(_tc_cap_join)gcc $(TC_GCC_EFFECTIVE) < $(MIN_GCC_VERSION); the $(TC_OVERLAY_GCC) overlay would satisfy it but the stock gcc was forced (LEGACY_TOOLCHAIN)
else ifneq ($(strip $(TC_OVERLAY_GCC)),)
TC_CAPABILITY_UNSUPPORTED := $(TC_CAPABILITY_UNSUPPORTED)$(_tc_cap_join)gcc $(TC_GCC_EFFECTIVE) < $(MIN_GCC_VERSION); the $(TC_OVERLAY_GCC) overlay is not enough either
else
TC_CAPABILITY_UNSUPPORTED := $(TC_CAPABILITY_UNSUPPORTED)$(_tc_cap_join)gcc $(TC_GCC_EFFECTIVE) < $(MIN_GCC_VERSION); no gcc overlay exists for this toolchain
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

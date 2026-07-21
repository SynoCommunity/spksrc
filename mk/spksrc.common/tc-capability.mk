###############################################################################
# spksrc.common/tc-capability.mk
#
# Lets a package declare what it NEEDS from a toolchain instead of enumerating
# the architectures where it happens to fail today:
#
#   MIN_GLIBC_VERSION = 2.20    needs glibc 2.20 or newer
#   MIN_GCC_VERSION   = 8       needs gcc 8 or newer
#   REQUIRE_64BIT     = 1       needs a 64-bit target   (checked in pre-check.mk)
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

# ---- glibc: a runtime floor, so too old means genuinely unsupported ---------
# Linking against a newer glibc than the NAS runs produces binaries that will not
# start, so nothing can lift this.
ifneq ($(strip $(MIN_GLIBC_VERSION)),)
ifneq ($(strip $(TC_GLIBC)),)
ifeq ($(call version_ge,$(TC_GLIBC),$(MIN_GLIBC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := glibc $(TC_GLIBC) < $(MIN_GLIBC_VERSION) (a runtime floor: no toolchain can lift it)
endif
endif
endif

# ---- gcc: the compiler the toolchain ships ----------------------------------
# Plain ifeq rather than a nested $(if): version_ge returns empty for false, and
# the message must not be split on the commas a $(if) would read as separators.
ifneq ($(strip $(MIN_GCC_VERSION)),)
ifneq ($(strip $(TC_GCC)),)
ifeq ($(call version_ge,$(TC_GCC),$(MIN_GCC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := gcc $(TC_GCC) < $(MIN_GCC_VERSION)
endif
endif
endif

endif # ifneq ARCH/TCVERSION

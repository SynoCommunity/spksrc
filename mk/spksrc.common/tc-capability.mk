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
# Everything is resolved WITHOUT building the toolchain, from the values encoded
# in the toolchain's own Makefile. That matters: reading the gcc back from a
# generated tc_vars.mk would make the answer depend on how the toolchain happened
# to be built last, so two clones could disagree.
#
# Variables provided (per ARCH/TCVERSION):
#   TC_STOCK_GCC     the toolchain's gcc     (from TC_DIST: gcc493 -> 4.9.3)
#   TC_STOCK_GLIBC   the toolchain's glibc   (from TC_GLIBC)
#   TC_STOCK_KERNEL  the toolchain's kernel  (from TC_KERNEL) -- a floor a package
#                    can gate on, e.g. an API that appeared in a given kernel.
#
# A failing check sets TC_CAPABILITY_UNSUPPORTED to a human sentence; pre-check.mk
# turns that into the arch-refusal error, next to UNSUPPORTED_ARCHS.
###############################################################################

ifneq ($(strip $(ARCH))$(strip $(TCVERSION)),)

_TC_CAP_MK := $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/Makefile

# Decode the gcc token of a TC_DIST. Three real shapes exist in the tree:
#
#   gcc493  gcc750  gcc850     3 digits -> 4.9.3  7.5.0  8.5.0
#   gcc1030 gcc1220            4 digits -> 10.3.0 12.2.0     (two-digit major)
#   gcc4374                    4 digits -> 4.3.7            (legacy DSM 5.2 form,
#                                                            trailing build digit)
#
# The 4-digit case is ambiguous, and getting it wrong is not cosmetic: reading
# gcc4374 as "43.7.4" makes an arch stuck on gcc 4.3.7 satisfy every conceivable
# MIN_GCC_VERSION -- the guard would wave through exactly what it exists to stop.
# Disambiguated on the major: 10 and 12 are plausible gcc majors, 43 is not.
# Anything up to 20 is treated as a major, which leaves room to keep counting.
TC_STOCK_GCC := $(shell sed -n 's/^TC_DIST *= *//p' $(_TC_CAP_MK) 2>/dev/null | \
                  sed -n 's/.*-gcc\([0-9]\+\)[_-].*/\1/p' | \
                  awk '{ n=length($$0); \
                         if (n==3) { printf "%s.%s.%s", substr($$0,1,1), substr($$0,2,1), substr($$0,3,1) } \
                         else if (n==4 && substr($$0,1,2)+0 <= 20) { printf "%s.%s.%s", substr($$0,1,2), substr($$0,3,1), substr($$0,4,1) } \
                         else if (n>=4) { printf "%s.%s.%s", substr($$0,1,1), substr($$0,2,1), substr($$0,3,1) } }')
TC_STOCK_GLIBC  := $(shell sed -n 's/^TC_GLIBC *= *//p' $(_TC_CAP_MK) 2>/dev/null)
TC_STOCK_KERNEL := $(shell sed -n 's/^TC_KERNEL *= *//p' $(_TC_CAP_MK) 2>/dev/null)

# ---- glibc: a runtime floor, so too old means genuinely unsupported ---------
# Linking against a newer glibc than the NAS runs produces binaries that will not
# start, so nothing can lift this.
ifneq ($(strip $(MIN_GLIBC_VERSION)),)
ifneq ($(strip $(TC_STOCK_GLIBC)),)
ifeq ($(call version_ge,$(TC_STOCK_GLIBC),$(MIN_GLIBC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := glibc $(TC_STOCK_GLIBC) < $(MIN_GLIBC_VERSION) (a runtime floor: no toolchain can lift it)
endif
endif
endif

# ---- gcc: the compiler the toolchain ships ----------------------------------
# Plain ifeq rather than a nested $(if): version_ge returns empty for false, and
# the message must not be split on the commas a $(if) would read as separators.
ifneq ($(strip $(MIN_GCC_VERSION)),)
ifneq ($(strip $(TC_STOCK_GCC)),)
ifeq ($(call version_ge,$(TC_STOCK_GCC),$(MIN_GCC_VERSION)),)
TC_CAPABILITY_UNSUPPORTED := gcc $(TC_STOCK_GCC) < $(MIN_GCC_VERSION)
endif
endif
endif

endif # ifneq ARCH/TCVERSION

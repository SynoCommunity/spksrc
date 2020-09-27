# Common definitions, shared by all makefiles

# all will be the default target, regardless of what is defined in the other
# makefiles.
default: all

# Stop on first error
SHELL := $(SHELL) -e

# Display message in a consistent way
MSG = echo "===> "

# Launch command in the working dir of a software with the right environment
RUN = cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV)

# Pip command
PIP ?= pip
# Why ask for the same thing twice? Always cache downloads
PIP_CACHE_OPT ?= --cache-dir $(PIP_DIR)
PIP_WHEEL_ARGS = wheel --no-binary :all: $(PIP_CACHE_OPT) --no-deps --requirement $(WORK_DIR)/wheelhouse/requirements.txt --wheel-dir $(WORK_DIR)/wheelhouse -b $(WORK_DIR)/wheelbuild
PIP_WHEEL = $(PIP) $(PIP_WHEEL_ARGS)

# Available languages
LANGUAGES = chs cht csy dan enu fre ger hun ita jpn krn nld nor plk ptb ptg rus spn sve trk

# Toolchains
AVAILABLE_TCS = $(notdir $(wildcard ../../toolchains/syno-*))
AVAILABLE_ARCHS = $(notdir $(subst syno-,/,$(AVAILABLE_TCS)))

# Toolchain filters
SUPPORTED_ARCHS = $(sort $(filter-out powerpc% ppc824% ppc854x%, $(AVAILABLE_ARCHS)))
LEGACY_ARCHS = $(sort $(filter-out $(SUPPORTED_ARCHS), $(AVAILABLE_ARCHS)))
# SRM - Synology Router Manager
SRM_ARCHS = northstarplus ipq806x dakota

# arch-tc to build 
# make all-general is now provided to build the general packages - same as built by github-build-action
ALL_GENERAL_ARCH_TC = 88f6281-6.1 armv7-6.1 armv7-1.2 x64-6.1 aarch64-6.1 evansport-6.1 ppc853x-5.2 qoriq-6.1

# Use generic archs when kernels are not needed
ARCHS_NO_KRNLSUPP = $(filter-out x64% armv7% aarch64%, $(SUPPORTED_ARCHS))

# remove archs for generic x64 build
ARCHS_DUPES := $(filter-out apollolake% avoton% braswell% broadwell% broadwellnk% bromolow% cedarview% denverton% dockerx64% geminilake% grantley% purley% kvmx64% x86% x86_64%, $(SUPPORTED_ARCHS))
# remove archs for generic aarch64 build
ARCHS_DUPES := $(filter-out rtd1296% armada37xx%, $(ARCHS_DUPES))
# optional remove archs for generic armv7 build
ifeq ($(findstring ARM7,$(GENERIC_ARCHS)),ARM7)
  ARCHS_DUPES := $(filter-out alpine% armada370% armada375% armada38x% armadaxp% comcerto2k% monaco% northstarplus% ipq806x% dakota%, $(ARCHS_DUPES))
else
  ARCHS_DUPES := $(filter-out armv7%, $(ARCHS_DUPES))
endif

# Available Arches
ARM5_ARCHES = 88f6281
ARM7_ARCHES = armv7 alpine armada370 armada375 armada38x armadaxp comcerto2k monaco hi3535 ipq806x northstarplus dakota
ARM8_ARCHES = aarch64 rtd1296 armada37xx
ARM_ARCHES = $(ARM5_ARCHES) $(ARM7_ARCHES) $(ARM8_ARCHES)
PPC_ARCHES = powerpc ppc824x ppc853x ppc854x qoriq
x86_ARCHES = evansport
x64_ARCHES = x64 apollolake avoton braswell broadwell broadwellnk bromolow cedarview denverton dockerx64 geminilake grantley purley kvmx64 x86 x86_64

# Load local configuration
LOCAL_CONFIG_MK = ../../local.mk
ifneq ($(wildcard $(LOCAL_CONFIG_MK)),)
include $(LOCAL_CONFIG_MK)
endif

# Relocate to set conditionally according to existing parallel options in caller
ifneq ($(PARALLEL_MAKE),)
ifeq ($(PARALLEL_MAKE),max)
NCPUS = $(shell grep -c ^processor /proc/cpuinfo)
else
NCPUS = $(PARALLEL_MAKE)
endif
ifeq ($(filter $(NCPUS),0 1),)
COMPILE_MAKE_OPTIONS += -j$(NCPUS)
endif
endif

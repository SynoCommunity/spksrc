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
PIP_WHEEL = $(PIP) wheel --no-binary :all: --no-deps --requirement $(WORK_DIR)/wheelhouse/requirements.txt --wheel-dir $(WORK_DIR)/wheelhouse --build-dir $(WORK_DIR)/wheelbuild

# Available languages
LANGUAGES = chs cht csy dan enu fre ger hun ita jpn krn nld nor plk ptb ptg rus spn sve trk

# Toolchains
AVAILABLE_TCS = $(notdir $(wildcard ../../toolchains/syno-*))
AVAILABLE_ARCHS = $(notdir $(subst syno-,/,$(AVAILABLE_TCS)))

# Toolchain filters
SUPPORTED_ARCHS = $(sort $(filter-out powerpc% ppc824% ppc854x%, $(AVAILABLE_ARCHS)))
LEGACY_ARCHS = $(sort $(filter-out $(SUPPORTED_ARCHS), $(AVAILABLE_ARCHS)))

# Use x64 when kernels are not needed
ARCHS_NO_KRNLSUPP = $(filter-out x64%, $(SUPPORTED_ARCHS))
ARCHS_DUPES = $(filter-out apollolake% avoton% braswell% broadwell% bromolow% cedarview% grantley% x86%, $(SUPPORTED_ARCHS))

# Available Arches
ARM5_ARCHES = 88f6281
ARM7_ARCHES = alpine armada370 armada375 armada38x armadaxp comcerto2k monaco hi3535 ipq806x northstarplus
ARM8_ARCHES = rtd1296
ARM_ARCHES = $(ARM5_ARCHES) $(ARM7_ARCHES) $(ARM8_ARCHES)
PPC_ARCHES = powerpc ppc824x ppc853x ppc854x qoriq
x86_ARCHES = evansport
x64_ARCHES = apollolake avoton braswell broadwell broadwellnk bromolow cedarview denverton dockerx64 grantley kvmx64 x86 x64 x86_64

# Load local configuration
LOCAL_CONFIG_MK = ../../local.mk
ifneq ($(wildcard $(LOCAL_CONFIG_MK)),)
include $(LOCAL_CONFIG_MK)
endif

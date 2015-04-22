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

# Pip command
PIP = pip
PIP_WHEEL = $(PIP) wheel --no-use-wheel --no-deps --wheel-dir $(STAGING_DIR)/wheelhouse

# Available languages
LANGUAGES = chs cht csy dan enu fre ger hun ita jpn krn nld nor plk ptb ptg rus spn sve trk

# Available Arches
ARM5_ARCHES = 88f5281 88f6281
ARM7_ARCHES = armada370 armadaxp armada375 alpine comcerto2k
ARM_ARCHES = $(ARM5_ARCHES) $(ARM7_ARCHES)
PPC_ARCHES = powerpc ppc824x ppc853x ppc854x qoriq
x86_ARCHES = evansport
x64_ARCHES = avoton bromolow cedarview x86 x64

# Load local configuration
LOCAL_CONFIG_MK = ../../local.mk
ifneq ($(wildcard $(LOCAL_CONFIG_MK)),)
include $(LOCAL_CONFIG_MK)
endif


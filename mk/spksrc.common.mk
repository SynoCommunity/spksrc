# Common definitions, shared by all makefiles

# Include base definitions (version macros, MSG, etc.) first
include ../../mk/spksrc.base.mk

###

# Set basedir in case called from spkrc/ or from normal sub-dir
# Note that github-action uses workspace/ in place of spksrc/
ifeq ($(BASEDIR),)
ifeq ($(filter spksrc workspace,$(shell basename $(CURDIR))),)
BASEDIR = ../../
endif
endif

# For legacy reasons keep $(PWD) call
PWD := $(CURDIR)

# all will be the default target, regardless of what is defined in the other
# makefiles.
default: all

# Launch command in the working dir of the package source and the right environment
RUN = cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV)

# fallback by default to native/python*
PIP ?= pip

# System default pip outside from build environment
PIP_SYSTEM = $(shell which pip)

# System default pip outside from build environment
PIP_NATIVE = $(WORK_DIR)/../../../native/$(or $(PYTHON_PACKAGE),$(SPK_NAME))/work-native/install/usr/local/bin/pip

# Why ask for the same thing twice? Always cache downloads
PIP_CACHE_OPT ?= --find-links $(PIP_DISTRIB_DIR) --cache-dir $(PIP_CACHE_DIR)
PIP_BASIC_OPT ?= --no-color --disable-pip-version-check
PIP_WHEEL_ARGS = wheel $(PIP_BASIC_OPT) --no-binary :all: $(PIP_CACHE_OPT) --no-deps --wheel-dir $(WHEELHOUSE)

# Adding --no-index only for crossenv
# to force using localy downloaded version
PIP_WHEEL_ARGS_CROSSENV = $(PIP_WHEEL_ARGS) --no-index

# BROKEN: https://github.com/pypa/pip/issues/1884
# Current implementation is a work-around for the
# lack of proper source download support from pip
PIP_DOWNLOAD_ARGS = download --no-index --find-links $(PIP_DISTRIB_DIR) --disable-pip-version-check --no-binary :all: --no-deps --dest $(PIP_DISTRIB_DIR) --no-build-isolation --exists-action w

# Available toolchains formatted as '{ARCH}-{TC}'
AVAILABLE_TOOLCHAINS = $(subst syno-,,$(filter-out %-rust,$(sort $(notdir $(wildcard $(BASEDIR)toolchain/syno-*)))))
AVAILABLE_TCVERSIONS = $(sort $(foreach arch,$(AVAILABLE_TOOLCHAINS),$(shell echo ${arch} | cut -f2 -d'-')))

# Available toolchains formatted as '{ARCH}-{TC}'
AVAILABLE_KERNEL = $(subst syno-,,$(sort $(notdir $(wildcard $(BASEDIR)kernel/syno-*))))
AVAILABLE_KERNEL_VERSIONS = $(sort $(foreach arch,$(AVAILABLE_KERNEL),$(shell echo ${arch} | cut -f2 -d'-')))

# Global arch definitions
include $(BASEDIR)mk/spksrc.archs.mk

# Load local configuration
LOCAL_CONFIG_MK = $(BASEDIR)local.mk
ifneq ($(wildcard $(LOCAL_CONFIG_MK)),)
include $(LOCAL_CONFIG_MK)
endif

# Filter to exclude TC versions greater than DEFAULT_TC (from local configuration)
TCVERSION_DUPES = $(addprefix %,$(filter-out $(DEFAULT_TC),$(AVAILABLE_TCVERSIONS)))

# remove unsupported (outdated) archs
ARCHS_DUPES_DEPRECATED += $(addsuffix %,$(DEPRECATED_ARCHS))

# Filter for all-supported
ARCHS_DUPES = $(ARCHS_WITH_GENERIC_SUPPORT) $(ARCHS_DUPES_DEPRECATED) $(TCVERSION_DUPES)

# supported: used for all-supported target
SUPPORTED_ARCHS = $(sort $(filter-out $(ARCHS_DUPES), $(AVAILABLE_TOOLCHAINS)))

# default: used for all-latest target
LATEST_ARCHS = $(foreach arch,$(sort $(basename $(subst -,.,$(basename $(subst .,,$(SUPPORTED_ARCHS)))))),$(arch)-$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $(arch)%, $(AVAILABLE_TOOLCHAINS)))))),$(sort $(filter $(arch)%, $(AVAILABLE_TOOLCHAINS))))))))

# legacy: used for all-legacy and when kernel support is used
#         all archs except generic archs
LEGACY_ARCHS = $(sort $(filter-out $(addsuffix %,$(GENERIC_ARCHS)), $(AVAILABLE_TOOLCHAINS)))

# Set parallel build mode
ifeq ($(PARALLEL_MAKE),)
# If not set but -j or -l argument passed, must
# manually specify the value of PARALLEL_MAKE
# as otherwise this will create too high load
ifneq ($(strip $(filter -j% -l%, $(shell ps T $$PPID))),)
PARALLEL_MAKE = nop
ENV += PARALLEL_MAKE=nop
# If not set, force max parallel build mode
else
PARALLEL_MAKE = max
ENV += PARALLEL_MAKE=max
endif
endif

# Allow parallel make to be disabled per package
ifeq ($(DISABLE_PARALLEL_MAKE),1)
PARALLEL_MAKE = nop
endif

# Set NCPUS based on PARALLEL_MAKE
ifeq ($(PARALLEL_MAKE),nop)
NCPUS = 1
else ifeq ($(PARALLEL_MAKE),max)
NCPUS = $(shell grep -c ^processor /proc/cpuinfo)
else
NCPUS = $(PARALLEL_MAKE)
endif

# Enable stats over parallel build mode
ifneq ($(filter 1 on ON,$(PSTAT)),)
PSTAT_TIME = time -o $(STATUS_LOG) --append --quiet
endif

DEFAULT_LOG  = $(LOG_DIR)/build$(or $(ARCH_SUFFIX),-noarch-$(TCVERSION)).log
CROSSENV_LOG = $(LOG_DIR)/build$(ARCH_SUFFIX)-crossenv.log
WHEEL_LOG    = $(LOG_DIR)/build$(ARCH_SUFFIX)-wheel.log
NATIVE_LOG   = $(LOG_DIR)/build-native-$(PKG_NAME).log
STATUS_LOG   = $(LOG_DIR)/status-build.log

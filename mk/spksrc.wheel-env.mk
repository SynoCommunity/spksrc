#
# Configuration for python wheel build
#

ifeq ($(strip $(WHEELS_DEFAULT)),)
WHEELS_DEFAULT = requirements.txt
endif
ifeq ($(strip $(WHEELS_LIMITED_API)),)
WHEELS_LIMITED_API = requirements-abi3.txt
endif
ifeq ($(strip $(WHEELS_PURE_PYTHON)),)
WHEELS_PURE_PYTHON = requirements-pure.txt
endif
ifeq ($(strip $(WHEELS_CROSS_COMPILE)),)
WHEELS_CROSS_COMPILE = requirements-cross.txt
endif

ifeq ($(strip $(WHEEL_DEFAULT_PREFIX)),)
# If no ARCH then pure by default
ifeq ($(strip $(ARCH)),)
WHEEL_DEFAULT_PREFIX = pure
else
WHEEL_DEFAULT_PREFIX = cross
endif
endif

ifeq ($(strip $(WHEEL_DEFAULT_PREFIX)),pure)
WHEEL_DEFAULT_REQUIREMENT = $(WHEELS_PURE_PYTHON)
else
WHEEL_DEFAULT_REQUIREMENT = $(WHEELS_CROSS_COMPILE)
endif

# For generating abi3 wheels with limited
# python API (e.g cp35 = Python 3.5)
ifeq ($(strip $(PYTHON_LIMITED_API)),)
PYTHON_LIMITED_API = cp35
endif

#
# Define _PYTHON_HOST_PLATFORM so wheel
# prefix in file naming matches `uname -m`
#
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
PYTHON_ARCH = armv5tel
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PYTHON_ARCH = armv7
endif

ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
PYTHON_ARCH = armv7l
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PYTHON_ARCH = aarch64
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PYTHON_ARCH = ppc
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PYTHON_ARCH = x86_64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PYTHON_ARCH += i686
endif

#
# Configuration for python wheel build
#

##### rust specific configurations
include ../../mk/spksrc.cross-rust-env.mk

# set PYTHON_*_PREFIX if unset
ifeq ($(strip $(PYTHON_STAGING_INSTALL_PREFIX)),)
PYTHON_STAGING_INSTALL_PREFIX = $(STAGING_INSTALL_PREFIX)
PYTHON_PREFIX = $(INSTALL_PREFIX)
endif

# set OPENSSL_*_PREFIX if unset
ifeq ($(strip $(OPENSSL_STAGING_PREFIX)),)
OPENSSL_STAGING_PREFIX = $(STAGING_INSTALL_PREFIX)
OPENSSL_PREFIX = $(INSTALL_PREFIX)
endif

# Enable pure-python packaging
ifeq ($(strip $(WHEELS_PURE_PYTHON_PACKAGING_ENABLE)),)
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = FALSE
WHEELS_2_DOWNLOAD = $(patsubst %$(WHEELS_PURE_PYTHON),,$(WHEELS))
else
WHEELS_2_DOWNLOAD = $(WHEELS)
endif

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
ifeq ($(strip $(WHEELS_CROSSENV_COMPILE)),)
WHEELS_CROSSENV_COMPILE = requirements-crossenv.txt
endif

ifeq ($(strip $(WHEEL_DEFAULT_PREFIX)),)
# If no ARCH then pure by default
# unless called using download-wheels
ifeq ($(MAKECMDGOALS),download-wheels)
WHEEL_DEFAULT_PREFIX = crossenv
else ifeq ($(strip $(ARCH)),)
WHEEL_DEFAULT_PREFIX = pure
else
WHEEL_DEFAULT_PREFIX = crossenv
endif
endif

ifeq ($(strip $(WHEEL_DEFAULT_PREFIX)),pure)
WHEELS_DEFAULT_REQUIREMENT = $(WHEELS_PURE_PYTHON)
else
WHEELS_DEFAULT_REQUIREMENT = $(WHEELS_CROSSENV_COMPILE)
endif

# For generating abi3 wheels with limited
# python API (e.g cp37 = Python 3.7)
ifeq ($(strip $(PYTHON_LIMITED_API)),)
PYTHON_LIMITED_API = cp37
endif

#
# Define _PYTHON_HOST_PLATFORM so wheel
# prefix in file naming matches 'uname -m'
#
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
PYTHON_ARCH = armv5tel
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
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
PYTHON_ARCH = i686
endif

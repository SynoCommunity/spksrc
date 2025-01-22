### crossenv rules
#   Creates a crossenv for cross-compiling wheels.
#   Uses "default" as fallback and create a symlink
#   between $(WORK_DIR)/crossenv -> crossenv-default.
#   Otherwise uses wheel <name>-<version>, then
#   fallback to wheel <name> only.
#   It also generates a crossenv specific python-cc.mk
#   located under $(WORK_DIR)/crossenv-<wheel>/build.

# Targets are executed in the following order:
#  crossenv_msg_target
#  pre_crossenv_target   (override with PRE_CROSSENV_TARGET)
#  build_crossenv_target (override with CROSSENV_TARGET)
#  post_crossenv_target  (override with POST_CROSSENV_TARGET)
# Variables:
#  WHEEL_NAME              Name of wheel to process
#  WHEEL_VERSION           Version of wheel to process (can be empty)

# Defined using PYTHON_PACKAGE_WORK_DIR from spksrc.python.mk or use local work directory
PYTHON_WORK_DIR = $(or $(wildcard $(PYTHON_PACKAGE_WORK_DIR)),$(wildcard $(WORK_DIR)))

# Other Python spk/python* related variables
PYTHON_PKG_VERS             = $(or $(lastword $(subst -, ,$(notdir $(patsubst %/,%,$(wildcard $(PYTHON_WORK_DIR)/Python-[0-9]*))))),$(SPK_VERS))
PYTHON_PKG_VERS_MAJOR_MINOR = $(or $(word 1,$(subst ., ,$(PYTHON_PKG_VERS))).$(word 2,$(subst ., ,$(PYTHON_PKG_VERS))),$(SPK_VERS_MAJOR_MINOR))
PYTHON_PKG_NAME             = python$(subst .,,$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_PKG_DIR              = Python-$(PYTHON_PKG_VERS)
#
HOSTPYTHON_LIB_NATIVE       = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/$(PYTHON_PKG_DIR)/build/lib.linux-$(shell uname -m)-$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_NATIVE_PATH          = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin)
PYTHON_NATIVE               = $(PYTHON_NATIVE_PATH)/python3
PYTHON_LIB_NATIVE           = $(abspath $(PYTHON_WORK_DIR)/$(PYTHON_PKG_DIR)/build/lib.linux-$(shell uname -m)-$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_LIB_CROSS            = $(abspath $(PYTHON_WORK_DIR)/$(PYTHON_PKG_DIR)/build/lib.linux-$(shell expr "$(TC_TARGET)" : '\([^-]*\)' )-$(PYTHON_PKG_VERS_MAJOR_MINOR))

# wheel crossenv definitions
CROSSENV_CONFIG_PATH = $(abspath $(PYTHON_WORK_DIR)/../crossenv)
CROSSENV_CONFIG_DEFAULT = $(CROSSENV_CONFIG_PATH)/requirements-default.txt
CROSSENV_PATH = $(abspath $(WORK_DIR)/crossenv-$(CROSSENV_BUILD_WHEEL)/)

###

ifeq ($(strip $(PRE_CROSSENV_TARGET)),)
PRE_CROSSENV_TARGET = pre_crossenv_target
else
$(PRE_CROSSENV_TARGET): crossenv_msg_target
endif
ifeq ($(strip $(CROSSENV_TARGET)),)
CROSSENV_TARGET = build_crossenv_target
else
$(CROSSENC_TARGET): $(CROSSENV_WHEEL_TARGET)
endif
ifeq ($(strip $(POST_CROSSENV_TARGET)),)
POST_CROSSENV_TARGET = post_crossenv_target
else
$(POST_CROSSENV_TARGET): $(CROSSENV_TARGET)
endif

###

# Check for <wheel>-<x.y>, then fallback to <wheel>, then default
ifneq ($(wildcard $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL_NAME)-$(WHEEL_VERSION).txt),)
CROSSENV_BUILD_WHEEL = $(WHEEL_NAME)-$(WHEEL_VERSION)
CROSSENV_BUILD_REQUIREMENTS = $(CROSSENV_CONFIG_PATH)/requirements-$(CROSSENV_BUILD_WHEEL).txt
else ifneq ($(wildcard $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL_NAME).txt),)
CROSSENV_BUILD_WHEEL = $(WHEEL_NAME)
CROSSENV_BUILD_REQUIREMENTS = $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL_NAME).txt
else
CROSSENV_BUILD_WHEEL = default
CROSSENV_BUILD_REQUIREMENTS = $(CROSSENV_CONFIG_DEFAULT)
endif

# Completion status file
CROSSENV_COOKIE = $(WORK_DIR)/.crossenv-$(CROSSENV_BUILD_WHEEL)_done

###

# default wheel packages to install in crossenv
ifneq ($(wildcard $(CROSSENV_BUILD_REQUIREMENTS) $(CROSSENV_CONFIG_DEFAULT)),)
CROSSENV_DEFAULT_PIP_VERSION = $(shell grep -h -E "^pip[<>=]=" $(wildcard $(CROSSENV_BUILD_REQUIREMENTS) $(CROSSENV_CONFIG_DEFAULT)) | head -1 | sed -E 's/.*[<>=]=//')
CROSSENV_DEFAULT_SETUPTOOLS_VERSION = $(shell grep -h -E "^setuptools[<>=]=" $(wildcard $(CROSSENV_BUILD_REQUIREMENTS) $(CROSSENV_CONFIG_DEFAULT)) | head -1 | sed -E 's/.*[<>=]=//')
CROSSENV_DEFAULT_WHEEL_VERSION = $(shell grep -h -E "^wheel[<>=]=" $(wildcard $(CROSSENV_BUILD_REQUIREMENTS) $(CROSSENV_CONFIG_DEFAULT)) | head -1 | sed -E 's/.*[<>=]=//')
endif

ifneq ($(CROSSENV_DEFAULT_PIP_VERSION),)
CROSSENV_DEFAULT_PIP = pip==$(CROSSENV_DEFAULT_PIP_VERSION)
else
CROSSENV_DEFAULT_PIP = pip
endif

ifneq ($(CROSSENV_DEFAULT_SETUPTOOLS_VERSION),)
CROSSENV_DEFAULT_SETUPTOOLS = setuptools==$(CROSSENV_DEFAULT_SETUPTOOLS_VERSION)
else
CROSSENV_DEFAULT_SETUPTOOLS = setuptools
endif

ifneq ($(CROSSENV_DEFAULT_WHEEL_VERSION),)
CROSSENV_DEFAULT_WHEEL = wheel==$(CROSSENV_DEFAULT_WHEEL_VERSION)
else
CROSSENV_DEFAULT_WHEEL = wheel
endif

###

crossenv_msg_target:
	@$(MSG) "Preparing crossenv for $(NAME)"

# Create per-arch caching directory:
# PIP_CACHE_DIR defaults to $(WORK_DIR)/pip
pre_crossenv_target: crossenv_msg_target
	@if [ -n "$(PIP_CACHE_OPT)" ] ; then \
	   mkdir -p $(PIP_CACHE_DIR) ; \
	fi; \

post_crossenv_target: $(CROSSENV_TARGET)

###

crossenv-%:
	@$(MSG) $(MAKE) ARCH=\"$(firstword $(subst -, ,$*))\" TCVERSION=\"$(lastword $(subst -, ,$*))\" WHEEL_NAME=\"$(WHEEL_NAME)\" WHEEL_VERSION=\"$(WHEEL_VERSION)\" crossenv
	@MAKEFLAGS= $(MAKE) ARCH="$(firstword $(subst -, ,$*))" TCVERSION="$(lastword $(subst -, ,$*))" WHEEL_NAME="$(WHEEL_NAME)" WHEEL_VERSION="$(WHEEL_VERSION)" crossenv --no-print-directory

####

# Defined using current install prefix by replacing package name using
# PYTHON_PACKAGE from spksrc.python.mk, else use local install prefix
ifneq ($(PYTHON_PACKAGE),)
PYTHON_INSTALL_PREFIX = $(subst $(SPK_NAME),$(PYTHON_PACKAGE),$(INSTALL_PREFIX))
else
PYTHON_INSTALL_PREFIX = $(INSTALL_PREFIX)
endif

# Equivalent to STAGING_INSTALL_PREFIX relative to found python install
ifeq ($(PYTHON_STAGING_INSTALL_PREFIX),)
PYTHON_STAGING_INSTALL_PREFIX = $(abspath $(PYTHON_WORK_DIR)/install/$(PYTHON_INSTALL_PREFIX))
endif

# set OPENSSL_*_PREFIX if unset
ifeq ($(strip $(OPENSSL_STAGING_PREFIX)),)
OPENSSL_STAGING_PREFIX = $(PYTHON_STAGING_INSTALL_PREFIX)
OPENSSL_PREFIX = $(PYTHON_INSTALL_PREFIX)
endif

# Mandatory for rustc wheel building at crossenv preparation time
# --> Using python-cc.mk defined variable when cross-compiling wheels at subsequent steps!
export PYO3_CROSS_LIB_DIR = $(PYTHON_STAGING_INSTALL_PREFIX)/lib/
export PYO3_CROSS_INCLUDE_DIR = $(PYTHON_STAGING_INSTALL_PREFIX)/include/
# Mandatory of using OPENSSL_*_DIR starting with cryptography version >= 40
# https://docs.rs/openssl/latest/openssl/#automatic
export OPENSSL_LIB_DIR = $(OPENSSL_STAGING_PREFIX)/lib/
export OPENSSL_INCLUDE_DIR = $(OPENSSL_STAGING_PREFIX)/include/

# set PYTHONPATH for spksrc.python-module.mk
export PYTHONPATH = $(PYTHON_LIB_NATIVE):$(PYTHON_STAGING_INSTALL_PREFIX)/lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR)/site-packages/

###

# Create the crossenv in preparation for
# cross-compiling all the necessary wheels
#
# To validate crossenv parameters:
#    $ work-<arch>-<version>/crossenv/cross/bin/python
#    >>> import sys
#    >>> sys.path
#
build_crossenv_target: SHELL:=/bin/bash
build_crossenv_target: pre_crossenv_target $(CROSSENV_PATH)/build/python-cc.mk
	@$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), CROSSENV: $(CROSSENV_BUILD_WHEEL) >> $(PSTAT_LOG)
	@$(MSG) Python sources: $(wildcard $(PYTHON_WORK_DIR)/Python-[0-9]*)
	@$(MSG) crossenv wheel packages: $(CROSSENV_DEFAULT_PIP), $(CROSSENV_DEFAULT_SETUPTOOLS), $(CROSSENV_DEFAULT_WHEEL)
	@$(MSG) crossenv requirement definition: $(CROSSENV_BUILD_REQUIREMENTS)
	mkdir -p $(PYTHON_LIB_CROSS)
	cp -RL $(HOSTPYTHON_LIB_NATIVE) $(abspath $(PYTHON_LIB_CROSS)/../)
	@echo $(PYTHON_NATIVE) -m crossenv $(abspath $(PYTHON_WORK_DIR)/install/$(PYTHON_INSTALL_PREFIX)/bin/python$(PYTHON_PKG_VERS_MAJOR_MINOR)) \
	                        --cc $(TC_PATH)$(TC_PREFIX)gcc \
	                        --cxx $(TC_PATH)$(TC_PREFIX)c++ \
	                        --ar $(TC_PATH)$(TC_PREFIX)ar \
	                        --sysroot $(TC_SYSROOT) \
	                        --env LIBRARY_PATH= \
	                        --manylinux manylinux2014 \
	                        "$(CROSSENV_PATH)"
	@$(RUN) $(PYTHON_NATIVE) -m crossenv $(abspath $(PYTHON_WORK_DIR)/install/$(PYTHON_INSTALL_PREFIX)/bin/python$(PYTHON_PKG_VERS_MAJOR_MINOR)) \
	                        --cc $(TC_PATH)$(TC_PREFIX)gcc \
	                        --cxx $(TC_PATH)$(TC_PREFIX)c++ \
	                        --ar $(TC_PATH)$(TC_PREFIX)ar \
	                        --sysroot $(TC_SYSROOT) \
	                        --env LIBRARY_PATH= \
	                        --manylinux manylinux2014 \
	                        "$(CROSSENV_PATH)"
ifeq ($(CROSSENV_BUILD_WHEEL),default)
	@$(MSG) Setting default crossenv $(CROSSENV_PATH)
	@$(MSG) ln -sf crossenv-default $(WORK_DIR)/crossenv
	@$(RUN) ln -sf crossenv-default $(WORK_DIR)/crossenv
endif
	@$(RUN) wget --no-verbose https://bootstrap.pypa.io/get-pip.py --directory-prefix=$(CROSSENV_PATH)/build ; \
	   $(RUN) chmod 755 $(CROSSENV_PATH)/build/get-pip.py
	@. $(CROSSENV_PATH)/bin/activate ; \
	   $(MSG) build-python install $(CROSSENV_DEFAULT_PIP) ; \
	   $(RUN) $$(which build-python) $(CROSSENV_PATH)/build/get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check ; \
	   $(MSG) cross-python Install $(CROSSENV_DEFAULT_PIP) ; \
	   $(RUN) $$(which cross-python) $(CROSSENV_PATH)/build/get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check
	@. $(CROSSENV_PATH)/bin/activate ; \
	   $(MSG) build-pip Install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL) ; \
	   $(RUN) $$(which build-pip) --cache-dir $(PIP_CACHE_DIR) --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL) ; \
	   $(MSG) cross-pip Install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL) ; \
	   $(RUN) $$(which cross-pip) --cache-dir $(PIP_CACHE_DIR) --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL)
	@$(MSG) [$(CROSSENV_PATH)] Processing $(CROSSENV_BUILD_REQUIREMENTS)
	@. $(CROSSENV_PATH)/bin/activate ; \
	   $(MSG) build-pip install -r $(CROSSENV_BUILD_REQUIREMENTS) ; \
	   $(RUN) \
	     PATH="$(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin):$(PATH)" \
	     LD_LIBRARY_PATH="$(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/lib):$(LD_LIBRARY_PATH)" \
	     $$(which build-pip) --cache-dir $(PIP_CACHE_DIR) --disable-pip-version-check install -r $(CROSSENV_BUILD_REQUIREMENTS) ; \
	   $(MSG) cross-pip Install -r $(CROSSENV_BUILD_REQUIREMENTS) ; \
	   $(RUN) \
	     PATH="$(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin):$(PATH)" \
	     LD_LIBRARY_PATH="$(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/lib):$(LD_LIBRARY_PATH)" \
	     $$(which cross-pip) --cache-dir $(PIP_CACHE_DIR) --disable-pip-version-check install -r $(CROSSENV_BUILD_REQUIREMENTS)
	@. $(CROSSENV_PATH)/bin/activate ; \
	   $(MSG) "Package list for $(CROSSENV_PATH):" ; \
	   $(RUN) $$(which cross-pip) list

##
## python-cc.mk
##
$(CROSSENV_PATH)/build/python-cc.mk:
	@$(MSG) "crossenv environment definition: $@"
	@mkdir -p $(CROSSENV_PATH)/build
	@echo BUILD_ARCH=$(shell expr "$(TC_TARGET)" : '\([^-]*\)' ) > $@
	@echo HOST_ARCH=$(shell uname -m) >> $@
	@echo CROSSENV_PATH=$(CROSSENV_PATH) >> $@
	@echo CROSSENV=$(CROSSENV_PATH)/bin/activate >> $@
	@echo HOSTPYTHON=$(abspath $(PYTHON_WORK_DIR)/$(PYTHON_PKG_DIR)/hostpython) >> $@
	@echo HOSTPYTHON_LIB_NATIVE=$(HOSTPYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_NATIVE=$(PYTHON_NATIVE) >> $@
	@echo PYTHON_NATIVE_PATH=$(PYTHON_NATIVE_PATH) >> $@
	@echo PYTHON_LIB_NATIVE=$(PYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_LIB_CROSS=$(PYTHON_LIB_CROSS) >> $@
	@echo PYTHON_SITE_PACKAGES_NATIVE=$(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR)/site-packages) >> $@
	@echo PYTHON_INTERPRETER=$(PYTHON_INSTALL_PREFIX)/bin/python$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_VERSION=$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_LIB_DIR=lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_INC_DIR=include/python$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYO3_CROSS_LIB_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/lib) >> $@
	@echo PYO3_CROSS_INCLUDE_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/include) >> $@
	@echo CMAKE_TOOLCHAIN_FILE=$(abspath $(CMAKE_TOOLCHAIN_WRK)) >> $@
	@echo MESON_CROSS_FILE=$(abspath $(MESON_TOOLCHAIN_WRK)) >> $@
	@echo OPENSSL_LIB_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/lib) >> $@
	@echo OPENSSL_INCLUDE_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/include) >> $@
	@echo PIP=$(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin/pip) >> $@
	@echo CROSS_COMPILE_WHEELS=1 >> $@
	@echo ADDITIONAL_WHEEL_BUILD_ARGS=--no-build-isolation >> $@
	@echo CROSSENV_BUILD_REQUIREMENTS=$(CROSSENV_BUILD_REQUIREMENTS) >> $@
	@echo CROSSENV_DEFAULT_PIP=$(CROSSENV_DEFAULT_PIP_VERSION) >> $@
	@echo CROSSENV_DEFAULT_SETUPTOOLS=$(CROSSENV_DEFAULT_SETUPTOOLS_VERSION) >> $@
	@echo CROSSENV_DEFAULT_WHEEL=$(CROSSENV_DEFAULT_WHEEL_VERSION) >> $@

ifeq ($(wildcard $(CROSSENV_COOKIE)),)
crossenv: $(CROSSENV_COOKIE)

$(CROSSENV_COOKIE): $(POST_CROSSENV_TARGET)
	$(create_target_dir)
	@touch -f $@
else
crossenv: ;
endif

# Set default sheel to bash
SHELL = /bin/bash

###

# where the wheel crossenv definitions are located
CROSSENV_CONFIG_PATH = $(abspath $(WORK_DIR)/../../../mk/crossenv)
CROSSENV_CONFIG_DEFAULT = $(CROSSENV_CONFIG_PATH)/requirements-default.txt
CROSSENV_PATH = $(abspath $(WORK_DIR)/crossenv-$(CROSSENV_BUILD_WHEEL)/)

# Check for wheel==x.y, then wheel, then default
ifneq ($(wildcard $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL).txt),)
CROSSENV_BUILD_WHEEL = $(WHEEL)
CROSSENV_BUILD_REQUIREMENTS = $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL).txt
else ifneq ($(wildcard $(CROSSENV_CONFIG_PATH)/requirements-$(shell echo $${WHEEL%%[<>=]=*}).txt),)
CROSSENV_BUILD_WHEEL = $(shell echo $${WHEEL%%[<>=]=*})
CROSSENV_BUILD_REQUIREMENTS = $(CROSSENV_CONFIG_PATH)/requirements-$(shell echo $${WHEEL%%[<>=]=*}).txt
else
CROSSENV_BUILD_WHEEL = default
CROSSENV_BUILD_REQUIREMENTS = $(CROSSENV_CONFIG_DEFAULT)
endif

###

.PHONY: crossenv_msg_target

crossenv_msg_target:
	@$(MSG) "Preparing crossenv for $(NAME)"

###

# default wheel packages to install in crossenv
CROSSENV_DEFAULT_PIP_VERSION = $(shell read version < <(grep -hnm 1 '^pip[<>=]=' $(wildcard $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL).txt $(CROSSENV_CONFIG_DEFAULT)) | head -1) && echo $${version#*[<>=]=})
CROSSENV_DEFAULT_SETUPTOOLS_VERSION = $(shell read version < <(grep -hnm 1 '^setuptools[<>=]=' $(wildcard $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL).txt $(CROSSENV_CONFIG_DEFAULT)) | head -1) && echo $${version#*[<>=]=})
CROSSENV_DEFAULT_WHEEL_VERSION = $(shell read version < <(grep -hnm 1 '^wheel[<>=]=' $(wildcard $(CROSSENV_CONFIG_PATH)/requirements-$(WHEEL).txt $(CROSSENV_CONFIG_DEFAULT)) | head -1) && echo $${version#*[<>=]=})

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

crossenv-%:
ifneq ($(filter error-%, $(CROSSENV_BUILD_WHEEL)),)
	$(MAKE) $(CROSSENV_BUILD_WHEEL)
else
	$(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) WHEEL=$(CROSSENV_BUILD_WHEEL) build-crossenv
endif

####

# Defined using PYTHON_PACKAGE_WORK_DIR from spksrc.python.mk or use local work directory
PYTHON_WORK_DIR = $(wildcard $(or $(PYTHON_PACKAGE_WORK_DIR),$(WORK_DIR)))

# Defined using current install prefix by replacing package name using PYTHON_PACKAGE from spksrc.python.mk, else use local install prefix
ifneq ($(PYTHON_PACKAGE),)
PYTHON_INSTALL_PREFIX = $(subst $(SPK_NAME),$(PYTHON_PACKAGE),$(INSTALL_PREFIX))
else
PYTHON_INSTALL_PREFIX = $(INSTALL_PREFIX)
endif

# Equivalent to STAGING_INSTALL_PREFIX relative to found python install
ifeq ($(PYTHON_STAGING_INSTALL_PREFIX),)
PYTHON_STAGING_INSTALL_PREFIX = $(PYTHON_WORK_DIR)/install/$(PYTHON_INSTALL_PREFIX)
endif

# set OPENSSL_*_PREFIX if unset
ifeq ($(strip $(OPENSSL_STAGING_PREFIX)),)
OPENSSL_STAGING_PREFIX = $(PYTHON_STAGING_INSTALL_PREFIX)
OPENSSL_PREFIX = $(PYTHON_INSTALL_PREFIX)
endif

##
## python-cc.mk
##
PYTHON_PKG_VERS = $(lastword $(subst -, ,$(wildcard $(PYTHON_WORK_DIR)/Python-*)))
PYTHON_PKG_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(PYTHON_PKG_VERS))).$(word 2,$(subst ., ,$(PYTHON_PKG_VERS)))
PYTHON_PKG_NAME = python$(subst .,,$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_PKG_DIR = Python-$(PYTHON_PKG_VERS)
HOST_ARCH = $(shell uname -m)
BUILD_ARCH = $(shell expr "$(TC_TARGET)" : '\([^-]*\)' )
PYTHON_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin/python3)
PIP_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin/pip)
HOSTPYTHON = $(abspath $(PYTHON_WORK_DIR)/$(PYTHON_PKG_DIR)/hostpython)
HOSTPYTHON_LIB_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/$(PYTHON_PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_LIB_NATIVE = $(abspath $(PYTHON_WORK_DIR)/$(PYTHON_PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_LIB_CROSS = $(abspath $(PYTHON_WORK_DIR)/$(PYTHON_PKG_DIR)/build/lib.linux-$(BUILD_ARCH)-$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_SITE_PACKAGES_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR)/site-packages)
PYTHON_LIB_DIR = lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR)
PYTHON_INC_DIR = include/python$(PYTHON_PKG_VERS_MAJOR_MINOR)

# Mandatory for rustc wheel building within crossenv
# --> Using python-cc.mk defined variable for cross-compiling wheels
export PYO3_CROSS_LIB_DIR = $(PYTHON_STAGING_INSTALL_PREFIX)/lib/
export PYO3_CROSS_INCLUDE_DIR = $(PYTHON_STAGING_INSTALL_PREFIX)/include/
# Mandatory of using OPENSSL_*_DIR starting with
# cryptography version >= 40
# https://docs.rs/openssl/latest/openssl/#automatic
export OPENSSL_LIB_DIR = $(OPENSSL_STAGING_PREFIX)/lib/
export OPENSSL_INCLUDE_DIR = $(OPENSSL_STAGING_PREFIX)/include/

# set PYTHONPATH for spksrc.python-module.mk
export PYTHONPATH = $(PYTHON_LIB_NATIVE):$(PYTHON_STAGING_INSTALL_PREFIX)/lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR)/site-packages/

# Required so native python and maturin binaries can always be found
export PATH := $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin):$(PATH)
export LD_LIBRARY_PATH := $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/lib):$(LD_LIBRARY_PATH)

###

# Create the crossenv in preparation for
# cross-compiling all the necessary wheels
#
# To validate crossenv parameters:
#    $ work-<arch>-<version>/crossenv/cross/bin/python
#    >>> import sys
#    >>> sys.path
#
.PHONY: crossenv
ifneq ($(wildcard $(CROSSENV_PATH)),)
build-crossenv:
	@$(MSG) Reusing existing crossenv $(CROSSENV_PATH)
else
build-crossenv: SHELL:=/bin/bash
build-crossenv: $(CROSSENV_PATH)/build/python-cc.mk
	@$(MSG) crossenv wheel packages: $(CROSSENV_DEFAULT_PIP), $(CROSSENV_DEFAULT_SETUPTOOLS), $(CROSSENV_DEFAULT_WHEEL)
	@$(MSG) crossenv requirements file = $(CROSSENV_BUILD_REQUIREMENTS)
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
	   $(MSG) $$(which build-python) $(CROSSENV_PATH)/build/get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check ; \
	   $(RUN) $$(which build-python) $(CROSSENV_PATH)/build/get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check ; \
	   $(MSG) $$(which cross-python) $(CROSSENV_PATH)/build/get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check ; \
	   $(RUN) $$(which cross-python) $(CROSSENV_PATH)/build/get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check
	@. $(CROSSENV_PATH)/bin/activate ; \
	   $(MSG) $$(which build-pip) --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL) ; \
	   $(RUN) $$(which build-pip) --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL) ; \
	   $(MSG) $$(which cross-pip) --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL) ; \
	   $(RUN) $$(which cross-pip) --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL)
	@$(MSG) [$(CROSSENV_PATH)] Processing $(CROSSENV_BUILD_REQUIREMENTS)
	@. $(CROSSENV_PATH)/bin/activate ; \
	   $(MSG) $$(which build-pip) --disable-pip-version-check install -r $(CROSSENV_BUILD_REQUIREMENTS) ; \
	   $(RUN) $$(which build-pip) --disable-pip-version-check install -r $(CROSSENV_BUILD_REQUIREMENTS) ; \
	   $(MSG) $$(which cross-pip) --disable-pip-version-check install -r $(CROSSENV_BUILD_REQUIREMENTS) ; \
	   $(RUN) $$(which cross-pip) --disable-pip-version-check install -r $(CROSSENV_BUILD_REQUIREMENTS)
#ifneq ($(PYTHON_LIB_NATIVE),$(PYTHON_LIB_CROSS))
#	cp $(PYTHON_LIB_CROSS)/_sysconfigdata_*.py $(PYTHON_LIB_NATIVE)/_sysconfigdata.py
#endif
	@. $(CROSSENV_PATH)/bin/activate ; \
	   $(MSG) "Package list for $(CROSSENV_PATH):" ; \
	   $(MSG) $$(which cross-pip) list ; \
	   $(RUN) $$(which cross-pip) list
endif

$(CROSSENV_PATH)/build/python-cc.mk:
	mkdir -p $(CROSSENV_PATH)/build
	@echo CROSSENV_PATH=$(CROSSENV_PATH) > $@
	@echo CROSSENV=$(CROSSENV_PATH)/bin/activate >> $@
	@echo HOSTPYTHON=$(HOSTPYTHON) >> $@
	@echo HOSTPYTHON_LIB_NATIVE=$(HOSTPYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_LIB_NATIVE=$(PYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_LIB_CROSS=$(PYTHON_LIB_CROSS) >> $@
	@echo PYTHON_SITE_PACKAGES_NATIVE=$(PYTHON_SITE_PACKAGES_NATIVE) >> $@
	@echo PYTHON_INTERPRETER=$(PYTHON_INSTALL_PREFIX)/bin/python$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_VERSION=$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_LIB_DIR=$(PYTHON_LIB_DIR) >> $@
	@echo PYTHON_INC_DIR=$(PYTHON_INC_DIR) >> $@
	@echo PYO3_CROSS_LIB_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/lib) >> $@
	@echo PYO3_CROSS_INCLUDE_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/include) >> $@
	@echo OPENSSL_LIB_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/lib) >> $@
	@echo OPENSSL_INCLUDE_DIR=$(abspath $(PYTHON_STAGING_INSTALL_PREFIX)/include) >> $@
	@echo PIP=$(PIP_NATIVE) >> $@
	@echo CROSS_COMPILE_WHEELS=1 >> $@
	@echo ADDITIONAL_WHEEL_BUILD_ARGS=--no-build-isolation >> $@
	@echo CROSSENV_BUILD_REQUIREMENTS=$(CROSSENV_BUILD_REQUIREMENTS) >> $@
	@echo CROSSENV_DEFAULT_PIP=$(CROSSENV_DEFAULT_PIP_VERSION) >> $@
	@echo CROSSENV_DEFAULT_SETUPTOOLS=$(CROSSENV_DEFAULT_SETUPTOOLS_VERSION) >> $@
	@echo CROSSENV_DEFAULT_WHEEL=$(CROSSENV_DEFAULT_WHEEL_VERSION) >> $@

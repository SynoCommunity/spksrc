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

# python-cc.mk
PYTHON_PKG_VERS = $(lastword $(subst -, ,$(wildcard $(WORK_DIR)/Python-*)))
PYTHON_PKG_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(PYTHON_PKG_VERS))).$(word 2,$(subst ., ,$(PYTHON_PKG_VERS)))
PYTHON_PKG_NAME = python$(subst .,,$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_PKG_DIR = Python-$(PYTHON_PKG_VERS)
HOST_ARCH = $(shell uname -m)
BUILD_ARCH = $(shell expr "$(TC_TARGET)" : '\([^-]*\)' )
PYTHON_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin/python3)
PIP_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/bin/pip)
HOSTPYTHON = $(abspath $(WORK_DIR)/$(PYTHON_PKG_DIR)/hostpython)
HOSTPYTHON_LIB_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/$(PYTHON_PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_LIB_NATIVE = $(abspath $(WORK_DIR)/$(PYTHON_PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PYTHON_PKG_VERS_MAJOR_MINOR))
PYTHON_SITE_PACKAGES_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PYTHON_PKG_NAME)/work-native/install/usr/local/lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR)/site-packages)
PYTHON_LIB_CROSS = $(CROSSENV_PATH)/build/lib.linux-$(BUILD_ARCH)-$(PYTHON_PKG_VERS_MAJOR_MINOR)
PYTHON_LIB_DIR = lib/python$(PYTHON_PKG_VERS_MAJOR_MINOR)
PYTHON_INC_DIR = include/python$(PYTHON_PKG_VERS_MAJOR_MINOR)

###

# Create the crossenv in preparation for
# cross-compiling all the necessary wheels
.PHONY: crossenv
ifneq ($(wildcard $(CROSSENV_PATH)),)
build-crossenv:
	@$(MSG) Reusing existing crossenv $(CROSSENV_PATH)
else
build-crossenv: SHELL:=/bin/bash
build-crossenv: $(CROSSENV_PATH)/build/python-cc.mk
	@$(MSG) crossenv wheel packages: $(CROSSENV_DEFAULT_PIP), $(CROSSENV_DEFAULT_SETUPTOOLS), $(CROSSENV_DEFAULT_WHEEL)
	@$(MSG) crossenv requirements file = $(CROSSENV_BUILD_REQUIREMENTS)
	mkdir -p "$(PYTHON_LIB_CROSS)"
	cp -RL $(HOSTPYTHON_LIB_NATIVE) "$(abspath $(PYTHON_LIB_CROSS)/../)"
	@echo $(PYTHON_NATIVE) -m crossenv $(STAGING_INSTALL_PREFIX)/bin/python$(PYTHON_PKG_VERS_MAJOR_MINOR) \
	                        --cc $(TC_PATH)$(TC_PREFIX)gcc \
	                        --cxx $(TC_PATH)$(TC_PREFIX)c++ \
	                        --ar $(TC_PATH)$(TC_PREFIX)ar \
	                        --sysroot $(TC_SYSROOT) \
	                        --env LIBRARY_PATH= \
	                        --manylinux manylinux2014 \
	                        "$(CROSSENV_PATH)"
	@$(RUN) $(PYTHON_NATIVE) -m crossenv $(STAGING_INSTALL_PREFIX)/bin/python$(PYTHON_PKG_VERS_MAJOR_MINOR) \
	                        --cc $(TC_PATH)$(TC_PREFIX)gcc \
	                        --cxx $(TC_PATH)$(TC_PREFIX)c++ \
	                        --ar $(TC_PATH)$(TC_PREFIX)ar \
	                        --sysroot $(TC_SYSROOT) \
	                        --env LIBRARY_PATH= \
	                        --manylinux manylinux2014 \
	                        "$(CROSSENV_PATH)"
ifeq ($(CROSSENV_BUILD_WHEEL),default)
	@$(MSG) Setting default crossenv $(CROSSENV_PATH)
	@$(RUN) ln -s crossenv-default crossenv
endif
	@. $(CROSSENV_PATH)/bin/activate && $(RUN) wget --no-verbose https://bootstrap.pypa.io/get-pip.py
	@. $(CROSSENV_PATH)/bin/activate ; \
	    $(RUN) build-python get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check ; \
	    $(RUN) python get-pip.py $(CROSSENV_DEFAULT_PIP) --no-setuptools --no-wheel --disable-pip-version-check
	@. $(CROSSENV_PATH)/bin/activate ; \
	    build-pip --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL) ; \
	    pip --disable-pip-version-check install $(CROSSENV_DEFAULT_SETUPTOOLS) $(CROSSENV_DEFAULT_WHEEL)
	@. $(CROSSENV_PATH)/bin/activate ; \
	    while IFS= read -r requirement ; do \
	       $(MSG) [$(CROSSENV_PATH)] Processing $${requirement} ; \
	       build-pip --disable-pip-version-check install $${requirement} ; \
	       pip --disable-pip-version-check install $${requirement} ; \
	    done < <(grep -sv  -e "^\#" -e "^\$$" $(CROSSENV_BUILD_REQUIREMENTS))
	@. $(CROSSENV_PATH)/bin/activate ; \
	    $(MSG) "Package list for $(CROSSENV_PATH):" ; \
	    pip freeze
#ifneq ($(PYTHON_LIB_NATIVE),$(PYTHON_LIB_CROSS))
#	cp $(PYTHON_LIB_CROSS)/_sysconfigdata_*.py $(PYTHON_LIB_NATIVE)/_sysconfigdata.py
#endif
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
	@echo PYTHON_INTERPRETER=$(INSTALL_PREFIX)/bin/python$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_VERSION=$(PYTHON_PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_LIB_DIR=$(PYTHON_LIB_DIR) >> $@
	@echo PYTHON_INC_DIR=$(PYTHON_INC_DIR) >> $@
	@echo PIP=$(PIP_NATIVE) >> $@
	@echo CROSS_COMPILE_WHEELS=1 >> $@
	@echo ADDITIONAL_WHEEL_BUILD_ARGS=--no-build-isolation >> $@
	@echo CROSSENV_BUILD_REQUIREMENTS=$(CROSSENV_BUILD_REQUIREMENTS) >> $@
	@echo CROSSENV_DEFAULT_PIP=$(CROSSENV_DEFAULT_PIP_VERSION) >> $@
	@echo CROSSENV_DEFAULT_SETUPTOOLS=$(CROSSENV_DEFAULT_SETUPTOOLS_VERSION) >> $@
	@echo CROSSENV_DEFAULT_WHEEL=$(CROSSENV_DEFAULT_WHEEL_VERSION) >> $@

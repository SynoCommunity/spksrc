# Build Meson programs
#
# prerequisites:
# - cross/module depends on meson + ninja + python -m pip wheel
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# meson specific configurations
include ../../mk/spksrc.cross-meson-env.mk

# configure using meson
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_python_configure_target
endif

# install using python
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_python_wheel_target
endif

# call-up ninja build process
include ../../mk/spksrc.cross-ninja.mk

###

# Define where is located the crossenv
CROSSENV_WHEEL_PATH = $(firstword $(wildcard $(WORK_DIR)/crossenv-$(PKG_NAME)-$(PKG_VERS) $(WORK_DIR)/crossenv-$(PKG_NAME) $(WORK_DIR)/crossenv-default))

# If using spksrc.python.mk with PYTHON_STAGING_PREFIX defined
# then redirect STAGING_INSTALL_PREFIX so rust
# wheels can find openssl and other libraries
ifneq ($(wildcard $(PYTHON_STAGING_PREFIX)),)
STAGING_INSTALL_PREFIX := $(PYTHON_STAGING_PREFIX)
endif

###

### Prepare crossenv
prepare_crossenv:
	@$(MSG) $(MAKE) WHEEL_NAME=\"$(PKG_NAME)\" WHEEL_VERSION=\"$(PKG_VERS)\" crossenv-$(ARCH)-$(TCVERSION)
	@MAKEFLAGS= $(MAKE) WHEEL_NAME="$(PKG_NAME)" WHEEL_VERSION="$(PKG_VERS)" crossenv-$(ARCH)-$(TCVERSION) --no-print-directory

.PHONY: meson_python_configure_target

# default meson python configure:
meson_python_configure_target: SHELL:=/bin/bash
meson_python_configure_target: prepare_crossenv
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@$(MSG) INSTALL_TARGET: [$(INSTALL_TARGET)]
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(MESON_BUILD_DIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(INSTALL_PREFIX)
	@. $(CROSSENV) ; \
	if [ -e "$(CROSSENV)" ] ; then \
	   export PATH=$(CROSSENV_PATH)/build/bin:$${PATH} ; \
	   $(MSG) "crossenv: [$(CROSSENV)]" ; \
	   $(MSG) "meson: [$$(which meson)]" ; \
	   $(MSG) "MESON_NATIVE_FILE: [$(MESON_NATIVE_FILE)]" ; \
	   $(MSG) "MESON_CROSS_FILE: [$(MESON_CROSS_FILE)]" ; \
	else \
	   echo "ERROR: crossenv not found!" ; \
	   exit 2 ; \
	fi ; \
	$(MSG) PATH=$${PATH} $$(which build-python) $(WORK_DIR)/$(PKG_DIR)/vendored-meson/meson/meson.py setup $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS) --native-file $(MESON_NATIVE_FILE) ; \
#	$(RUN) PATH=$${PATH} $$(which build-python) $(WORK_DIR)/$(PKG_DIR)/vendored-meson/meson/meson.py setup $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS) --native-file $(MESON_NATIVE_FILE) ; \
#	cd $(MESON_BASE_DIR) && env $(ENV) PATH=$${PATH} $$(which build-python) $(WORK_DIR)/$(PKG_DIR)/vendored-meson/meson/meson.py setup $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS) ; \
	cd $(MESON_BASE_DIR) && env $(ENV) PATH=$${PATH} $$(which build-python) $(WORK_DIR)/$(PKG_DIR)/vendored-meson/meson/meson.py setup $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS) --native-file $(MESON_NATIVE_FILE)

.PHONY: install_python_wheel_target

install_python_wheel_target:
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(MESON_BUILD_DIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(INSTALL_PREFIX)
	@. $(CROSSENV) ; \
	if [ -e "$(CROSSENV)" ] ; then \
	   export PATH=$${PATH}:$(CROSSENV_PATH)/build/bin ; \
	   $(MSG) "crossenv: [$(CROSSENV)]" ; \
	   $(MSG) "python: [$$(which build-python)]" ; \
	else \
	   echo "ERROR: crossenv not found!" ; \
	   exit 2 ; \
	fi ; \
	$(MSG) \
	   _PYTHON_HOST_PLATFORM=\"$(TC_TARGET)\" \
	   PATH=$${PATH} \
	   $$(which build-python) -m pip \
	   $(PIP_WHEEL_ARGS) \
	   --no-build-isolation \
	   $(WORK_DIR)/$(PKG_DIR) ; \
	$(RUN) \
	   _PYTHON_HOST_PLATFORM="$(TC_TARGET)" \
	   PATH=$${PATH} \
	   $$(which build-python) -m pip \
	   $(PIP_WHEEL_ARGS) \
	   --no-build-isolation \
	   $(WORK_DIR)/$(PKG_DIR)

###

# Use crossenv
include ../../mk/spksrc.crossenv.mk

## python wheel specific configurations
include ../../mk/spksrc.wheel-env.mk

## install wheel specific routines
include ../../mk/spksrc.wheel-install.mk

###

# call-up regular build process
include ../../mk/spksrc.cross-cc.mk

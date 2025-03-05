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

# If using a local meson from package
# use direct meson+ninja build
ifneq ($(strip $(VENDOR_MESON)),)

# configure using meson
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_python_configure_target
endif

# Else using default through pip
else
PRE_CONFIGURE_TARGET = $(MESON_CROSS_TOOLCHAIN_PKG)
CONFIGURE_TARGET = prepare_crossenv
COMPILE_TARGET = nop
endif

# install using python
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_python_wheel_target
endif

###

# Define meson-python use-case
MESON_PYTHON = 1

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
meson_python_configure_target: prepare_crossenv $(MESON_CROSS_TOOLCHAIN_PKG)
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@set -o pipefail; { \
	$(MSG) "- Build path: [$(MESON_BUILD_DIR)]" ; \
	$(MSG) "- Configure ARGS: [$(CONFIGURE_ARGS)]" ; \
	$(MSG) "- Install prefix: [$(INSTALL_PREFIX)]" ; \
	$(MSG) "- Cross-file: [$(MESON_CROSS_TOOLCHAIN_PKG)]" ; \
	. $(CROSSENV) ; \
	if [ -e "$(CROSSENV)" ] ; then \
	   export PATH=$(call dedup,$(CROSSENV_PATH)/cross/bin:$(CROSSENV_PATH)/build/bin:$${PATH}, :) ; \
	   $(MSG) "- crossenv: [$(CROSSENV)]" ; \
	   $(MSG) "- cython: [$$(which cython)]" ; \
	else \
	   echo "ERROR: crossenv not found!" ; \
	   exit 2 ; \
	fi ; \
	if [ "$(VENDOR_MESON)" ] ; then \
	   meson="$$(which build-python) $(VENDOR_MESON)" ; \
	else \
	   meson="$$(which meson)" ; \
	fi ; \
	$(MSG) "- meson: [$${meson}]" ; \
	$(MSG) \
	   PATH=$${PATH} \
	   $${meson} setup \
	   $(MESON_BUILD_DIR) \
	   -Dprefix=$(INSTALL_PREFIX) \
	   $(CONFIGURE_ARGS) ; \
	cd $(MESON_BASE_DIR) && \
	   PATH=$${PATH} \
	   $${meson} setup \
	   $(MESON_BUILD_DIR) \
	   -Dprefix=$(INSTALL_PREFIX) \
	   $(CONFIGURE_ARGS) ; \
	} > >(tee --append $(WHEEL_LOG)) 2>&1 ; [ $${PIPESTATUS[0]} -eq 0 ] || false

.PHONY: install_python_wheel_target

install_python_wheel_target: SHELL:=/bin/bash
install_python_wheel_target:
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@set -o pipefail; { \
	. $(CROSSENV) ; \
	if [ -e "$(CROSSENV)" ] ; then \
	   export PATH=$(call dedup,$(CROSSENV_PATH)/cross/bin:$(CROSSENV_PATH)/build/bin:$(CROSSENV_PATH)/bin:$${PATH}, :) ; \
	   $(MSG) "- crossenv: [$(CROSSENV)]" ; \
	   $(MSG) "- meson: [$$(which meson)]" ; \
	   $(MSG) "- python: [$$(which cross-python)]" ; \
	else \
	   echo "ERROR: crossenv not found!" ; \
	   exit 2 ; \
	fi ; \
	$(MSG) \
	   _PYTHON_HOST_PLATFORM=\"$(TC_TARGET)\" \
	   PATH=$${PATH} \
	   $$(which cross-python) -m pip wheel . \
	   --config-settings=setup-args=\"--cross-file=$(MESON_CROSS_TOOLCHAIN_PKG)\" \
	   --config-settings=setup-args=\"--native-file=$(MESON_NATIVE_FILE)\" \
	   --config-settings=install-args=\"--tags=runtime,python-runtime\" \
	   --config-settings=build-dir=\"$(MESON_BUILD_DIR)\" \
	   --no-build-isolation \
	   --wheel-dir $(WHEELHOUSE) ; \
	$(RUN) \
	   _PYTHON_HOST_PLATFORM="$(TC_TARGET)" \
	   PATH=$${PATH} \
	   $$(which cross-python) -m pip wheel . \
	   --config-settings=setup-args="--cross-file=$(MESON_CROSS_TOOLCHAIN_PKG)" \
	   --config-settings=setup-args="--native-file=$(MESON_NATIVE_FILE)" \
	   --config-settings=install-args="--tags=runtime,python-runtime" \
	   --config-settings=build-dir="$(MESON_BUILD_DIR)" \
	   --no-build-isolation \
	   --wheel-dir $(WHEELHOUSE) ; \
	} > >(tee --append $(WHEEL_LOG)) 2>&1 ; [ $${PIPESTATUS[0]} -eq 0 ] || false

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

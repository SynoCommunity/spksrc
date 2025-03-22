# Build Meson programs
#
# prerequisites:
# - cross/module depends on meson + ninja + python -m pip wheel
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

###

# Define meson-python use-case
MESON_PYTHON = 1

# meson specific configurations
include ../../mk/spksrc.cross-meson-env.mk

# configure part of the pip wheel process using:
#   --config-settings=setup-args='<value>'
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = prepare_crossenv $(MESON_CROSS_TOOLCHAIN_PKG)
endif

# compile part of the pip wheel process, no config-settings available
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = nop
endif

# install using python pip wheel process using:
#   --config-settings=install-args='<value>'
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_python_wheel_target
endif

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

.PHONY: install_python_wheel_target

install_python_wheel_target: SHELL:=/bin/bash
install_python_wheel_target:
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@set -o pipefail; { \
	. $(CROSSENV) ; \
	if [ -e "$(CROSSENV)" ] ; then \
	   export PATH=$(call dedup,$(CROSSENV_PATH)/cross/bin:$(CROSSENV_PATH)/build/bin:$(CROSSENV_PATH)/bin:$${PATH}, :) ; \
	   export PKG_CONFIG_PATH=$(STAGING_INSTALL_PREFIX)/lib/pkgconfig ; \
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
	   $$(which cross-python) -m build -w -n -x . \
	   $(foreach arg,$(CONFIGURE_ARGS),-Csetup-args=\"$(arg)\" ) \
	   $(foreach arg,$(INSTALL_ARGS),-Cinstall-args=\"$(arg)\" ) \
	   -Cbuilddir=\"$(MESON_BUILD_DIR)\" \
	   --outdir $(WHEELHOUSE) \
	   --verbose ; \
	cd $(MESON_BASE_DIR) && env $(ENV_MESON) \
	   _PYTHON_HOST_PLATFORM="$(TC_TARGET)" \
	   PATH=$${PATH} \
	   $$(which cross-python) -m build -w -n -x . \
	   $(foreach arg,$(CONFIGURE_ARGS),-Csetup-args="$(arg)" ) \
	   $(foreach arg,$(INSTALL_ARGS),-Cinstall-args="$(arg)" ) \
	   -Cbuilddir="$(MESON_BUILD_DIR)" \
	   --outdir $(WHEELHOUSE) \
	   --verbose ; \
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

# python-meson wheel build
#
# By default uses $(CROSSENV)/bin/cross-python -m build
# Although can also work using $(CROSSENV)/cross-python -m pip
#
# configure part of the wheel process uses:
#     pip: --config-settings=setup-args='<value>'
#   build: -Csetup-args='<value>'
#
# install using python wheel process uses:
#     pip: --config-settings=install-args='<value>'
#   build: -Cinstall-args='<value>'
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

###

# Define meson-python specific use-case
MESON_PYTHON = 1

# meson specific configurations
include ../../mk/spksrc.cross-meson-env.mk

# meson cross-file usage definition
include ../../mk/spksrc.cross-meson-crossfile.mk

# 1- Prepare the crossenv
# 2- Generate the per-dependency cross-file definition
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = prepare_crossenv $(MESON_CROSS_FILE_PKG)
endif

ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = build_meson_python_wheel
endif

ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_meson_python_wheel
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
	@$(MSG) $(MAKE) WHEEL_NAME=\"$(or $(WHEEL_NAME),$(PKG_NAME))\" WHEEL_VERSION=\"$(PKG_VERS)\" crossenv-$(ARCH)-$(TCVERSION)
	@MAKEFLAGS= $(MAKE) WHEEL_NAME="$(or $(WHEEL_NAME),$(PKG_NAME))" WHEEL_VERSION="$(PKG_VERS)" crossenv-$(ARCH)-$(TCVERSION) --no-print-directory

.PHONY: build_meson_python_wheel

build_meson_python_wheel: SHELL:=/bin/bash
build_meson_python_wheel:
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

.PHONY: install_meson_python_wheel

install_meson_python_wheel: SHELL:=/bin/bash
install_meson_python_wheel:
	@set -o pipefail; { \
	$(MSG) $(MAKE) REQUIREMENT=\"$(PKG_NAME)==$(PKG_VERS)\" \
	               WHEEL_NAME=\"$(or $(WHEEL_NAME),$(PKG_NAME))\" \
	               WHEEL_VERSION=\"$(PKG_VERS)\" \
	               WHEEL_TYPE=\"cross\" \
	               wheel_install ; \
	MAKEFLAGS= $(MAKE) REQUIREMENT="$(PKG_NAME)==$(PKG_VERS)" \
	                   WHEEL_NAME="$(or $(WHEEL_NAME),$(PKG_NAME))" \
	                   WHEEL_VERSION="$(PKG_VERS)" \
	                   WHEEL_TYPE="cross" \
	                   --no-print-directory \
	                   wheel_install ; \
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

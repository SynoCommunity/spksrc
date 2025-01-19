### Python wheel rules
#   Invoke make to make a wheel for a python module.
#   You can do some customization through python-cc.mk

# Python module targets
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = nop
endif
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = build_python_wheel_target
endif
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = nop
endif
ifeq ($(strip $(POST_INSTALL_TARGET)),)
POST_INSTALL_TARGET = post_install_python_wheel_target
endif

# Resume with standard spksrc.cross-cc.mk
include ../../mk/spksrc.cross-cc.mk

# Define where is located the crossenv
CROSSENV_MODULE_PATH = $(firstword $(wildcard $(WORK_DIR)/crossenv-$(PKG_NAME)-$(PKG_VERS) $(WORK_DIR)/crossenv-$(PKG_NAME) $(WORK_DIR)/crossenv-default))

# If using spksrc.python.mk with PYTHON_STAGING_PREFIX defined
# then redirect STAGING_INSTALL_PREFIX so rust
# wheels can find openssl and other libraries
ifneq ($(wildcard $(PYTHON_STAGING_PREFIX)),)
STAGING_INSTALL_PREFIX := $(PYTHON_STAGING_PREFIX)
endif

### Prepare crossenv
build_crossenv_module:
	@$(MSG) WHEEL="$(PKG_NAME)-$(PKG_VERS)" $(MAKE) crossenv-$(ARCH)-$(TCVERSION)
	@WHEEL="$(PKG_NAME)-$(PKG_VERS)" $(MAKE) crossenv-$(ARCH)-$(TCVERSION)

### Python wheel rules
build_python_wheel_target: build_crossenv_module
	$(foreach e,$(shell cat $(CROSSENV_MODULE_PATH)/build/python-cc.mk),$(eval $(e)))
	@. $(CROSSENV) ; \
	$(MSG) _PYTHON_HOST_PLATFORM=$(TC_TARGET) cross-python3 -m build $(BUILD_ARGS) --wheel $(WHEELS_BUILD_ARGS) --outdir $(WHEELHOUSE) ; \
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) cross-python3 -m build $(BUILD_ARGS) --wheel $(WHEELS_BUILD_ARGS) --outdir $(WHEELHOUSE)
	@$(MSG) $(MAKE) REQUIREMENT=\"$(PKG_NAME)==$(PKG_VERS)\" WHEEL_NAME=\"$(PKG_NAME)\" WHEEL_VERSION=\"$(PKG_VERS)\" WHEEL_TYPE=\"cross\" wheel_install
	-@MAKEFLAGS= $(MAKE) REQUIREMENT="$(PKG_NAME)==$(PKG_VERS)" WHEEL_NAME="$(PKG_NAME)" WHEEL_VERSION="$(PKG_VERS)" WHEEL_TYPE="cross" --no-print-directory wheel_install

post_install_python_wheel_target: $(WHEEL_TARGET) install_python_wheel

all: install

###

# Use crossenv
include ../../mk/spksrc.crossenv.mk

## python wheel specific configurations
include ../../mk/spksrc.wheel-env.mk

## install wheel specific routines
include ../../mk/spksrc.wheel-install.mk

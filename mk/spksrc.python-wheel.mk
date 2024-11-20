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

# Fetch python variables
-include $(WORK_DIR)/crossenv/build/python-cc.mk

# If using spk.python.mk with PYTHON_STAGING_PREFIX defined
# then redirect STAGING_INSTALL_PREFIX so rust
# wheels can find openssl and other libraries
ifneq ($(wildcard $(PYTHON_STAGING_PREFIX)),)
STAGING_INSTALL_PREFIX := $(PYTHON_STAGING_PREFIX)
endif

# Python module variables
ifeq ($(strip $(PYTHONPATH)),)
PYTHONPATH = $(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/
endif

## python wheel specific configurations
include ../../mk/spksrc.wheel-env.mk

### Python wheel rules
build_python_wheel_target:
	@$(MSG) "PYTHON WHEEL: activate crossenv found: $(CROSSENV)"
	@$(MSG) "CROSSENV_PATH = $(CROSSENV_PATH)"
	@. $(CROSSENV_PATH)/bin/activate ; \
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) python3 -m build $(BUILD_ARGS) --wheel $(WHEELS_BUILD_ARGS) --outdir $(WHEELHOUSE)
	@$(RUN) echo "$(PKG_NAME)==$(PKG_VERS)" >> $(WHEELHOUSE)/$(WHEELS_CROSS_COMPILE)

post_install_python_wheel_target: $(WHEEL_TARGET) install_python_wheel

all: install

###

# Use crossenv
include ../../mk/spksrc.crossenv.mk

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
-include $(WORK_DIR)/python-cc.mk

# Python module variables
PYTHONPATH = $(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/

## python wheel specific configurations
include ../../mk/spksrc.wheel-env.mk

### Python wheel rules
build_python_wheel_target:
ifeq ($(strip $(CROSSENV)),)
# Python 2 way
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" $(BUILD_ARGS) bdist_wheel $(WHEELS_BUILD_ARGS) -d $(WHEELHOUSE)
else
# Python 3 case: using crossenv helper
	@. $(CROSSENV) && $(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) python3 setup.py $(BUILD_ARGS) bdist_wheel $(WHEELS_BUILD_ARGS) -d $(WHEELHOUSE)
endif
	@$(RUN) echo "$(PKG_NAME)==$(PKG_VERS)" >> $(WHEELHOUSE)/$(WHEELS_CROSS_COMPILE)

post_install_python_wheel_target: $(WHEEL_TARGET) install_python_wheel

all: install

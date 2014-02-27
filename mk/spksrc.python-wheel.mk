### Python wheel rules
#   Invoke make to make a wheel for a python module. 
# You can do some customization through python-cc.mk

# Python module targets
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = nope
endif
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = compile_python_module
endif
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = wheel_python_module
endif

# Resume with standard spksrc.cross-cc.mk
include ../../mk/spksrc.cross-cc.mk

# Fetch python variables
-include $(WORK_DIR)/python-cc.mk

# Python module variables
PYTHONPATH = $(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/


### Python wheel rules
compile_python_module:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build $(BUILD_ARGS)

wheel_python_module:
	@mkdir -p $(INSTALL_DIR)$(INSTALL_PREFIX)/share
	mkdir -p $(WHEEL_DIR)/$(ARCH)
	# Patching setup.py, blatantly stolen from pip
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" bdist_wheel -d $(INSTALL_DIR)$(INSTALL_PREFIX)/share
	# Using $(ARCH) folder, we cannot determine the correct ARCH on the host
	@mv $(INSTALL_DIR)$(INSTALL_PREFIX)/share/$(PKG_NAME)-$(PKG_VERS)*.whl $(WHEEL_DIR)/$(ARCH)/$(PKG_NAME)-$(PKG_VERS)-cp27-none-any.whl

all: install

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
	$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py bdist_wheel -d $(INSTALL_DIR)$(INSTALL_PREFIX)/share
	#TODO: Fix naming based on ARCH
	@mv $(INSTALL_DIR)$(INSTALL_PREFIX)/share/$(PKG_NAME)-$(PKG_VERS)*.whl $(INSTALL_DIR)$(INSTALL_PREFIX)/share/$(PKG_NAME)-$(PKG_VERS).whl

all: install

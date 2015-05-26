### Python wheel rules
#   Invoke make to make a wheel for a python module. 
# You can do some customization through python-cc.mk

# Python module targets
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = nope
endif
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = nope
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
wheel_python_module:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" bdist_wheel -d $(WORK_DIR)/wheelhouse
	@rename -f 's/linux_i686/any/g' $(WORK_DIR)/wheelhouse/*.whl
	@rename -f 's/linux_x86_64/any/g' $(WORK_DIR)/wheelhouse/*.whl
	@rename -f 's/cp34m/none/g' $(WORK_DIR)/wheelhouse/*.whl

all: install

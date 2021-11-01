### Python wheel rules
#   Invoke make to make a wheel for a python module.
#   You can do some customization through python-cc.mk

# Python module targets
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = nop
endif
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = build_python_wheel
endif
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_python_wheel
endif

# Resume with standard spksrc.cross-cc.mk
include ../../mk/spksrc.cross-cc.mk

# Fetch python variables
-include $(WORK_DIR)/python-cc.mk

# Python module variables
PYTHONPATH = $(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/


### Python wheel rules
build_python_wheel:
ifeq ($(strip $(CROSSENV)),)
# Python 2 way
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" $(BUILD_ARGS) bdist_wheel -d $(WHEELHOUSE)
else
# Python 3 case: using crossenv helper
	@. $(CROSSENV) && $(RUN) PYTHONPATH=$(PYTHONPATH) python -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" $(BUILD_ARGS) bdist_wheel -d $(WHEELHOUSE)
endif

install_python_wheel: $(WHEEL_TARGET)
	@if [ -d "$(WHEELHOUSE)" ] ; then \
		mkdir -p $(STAGING_INSTALL_WHEELHOUSE) ; \
		cd $(WHEELHOUSE) && \
		  for w in *.whl; do \
		    cp -f $$w $(STAGING_INSTALL_WHEELHOUSE)/`echo $$w | cut -d"-" -f -3`-none-any.whl; \
		  done ; \
	fi

all: install

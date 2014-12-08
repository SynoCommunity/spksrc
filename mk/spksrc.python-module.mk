### Python module rules
#   Invoke make to (cross-) compile a python module. 
# You can do some customization through python-cc.mk

# Python module targets
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = nope
endif
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = compile_python_module
endif
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_python_module
endif

# Resume with standard spksrc.cross-cc.mk
include ../../mk/spksrc.cross-cc.mk

# Fetch python variables
-include $(WORK_DIR)/python-cc.mk

# Python module variables
PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/


### Python module rules
compile_python_module:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build $(BUILD_ARGS)

install_python_module:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR) --prefix $(INSTALL_PREFIX) $(INSTALL_ARGS)

fix_shebang_python_module:
	@cat PLIST | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    bin) \
	      echo -n "Fixing shebang for $${file}... " ; \
	      sed -i -e 's|^#!.*$$|#!$(PYTHON_INTERPRETER)|g' $(INSTALL_DIR)$(INSTALL_PREFIX)/$${file} > /dev/null 2>&1 && echo "ok" || echo "failed!" \
	      ;; \
	  esac ; \
	done

all: install fix_shebang_python_module


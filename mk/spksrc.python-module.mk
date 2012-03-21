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
include $(WORK_DIR)/python-cc.mk

# Python module variables
PYTHONPATH = $(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/


### Python module rules
compile_python_module:
	@if [ ! -d $(PYTHON_LIB_CROSS).bak ]; then \
		mv $(PYTHON_LIB_CROSS) $(PYTHON_LIB_CROSS).bak; \
	fi
	@cp -R $(HOSTPYTHON_LIB_NATIVE) $(PYTHON_LIB_CROSS)
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build $(BUILD_ARGS)
	@mv $(PYTHON_LIB_CROSS).bak $(PYTHON_LIB_CROSS)

install_python_module:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR) --prefix $(INSTALL_PREFIX) $(INSTALL_ARGS)

fix_shebang_python_module:
	@cat PLIST | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    bin) \
	      echo -n "Fixing shebang for $${file}... " ; \
	      sed -i -e 's|^#!.*$$|#!$(INSTALL_PREFIX)/bin/python|g' $(INSTALL_DIR)$(INSTALL_PREFIX)/$${file} > /dev/null 2>&1 && echo "ok" || echo "failed!" \
	      ;; \
	  esac ; \
	done

all: install fix_shebang_python_module


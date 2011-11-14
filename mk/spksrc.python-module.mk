# Python module targets
CONFIGURE_TARGET = nop
COMPILE_TARGET = compile_python_module
INSTALL_TARGET = install_python_module

# Fetch python variables
include $(WORK_DIR)/python-cc.mk

# Resume with standard spksrc.cross-cc.mk
include ../../mk/spksrc.cross-cc.mk

# Python module variables
PYTHONPATH = $(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/


### Python module rules
nop: ;

compile_python_module:
	@if [ ! -d $(PYTHON_LIB_CROSS).bak ]; then \
		mv $(PYTHON_LIB_CROSS) $(PYTHON_LIB_CROSS).bak; \
	fi
	@cp -R $(HOSTPYTHON_LIB_NATIVE) $(PYTHON_LIB_CROSS)
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build
	@mv $(PYTHON_LIB_CROSS).bak $(PYTHON_LIB_CROSS)

install_python_module:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR)

fix_shebang_python_module:
	@cat PLIST | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    bin) \
	      echo "Fixing shebang for $${file}" ; \
	      sed -i -e 's|^#!.*$$|#!$(INSTALL_PREFIX)/bin/python|g' $(INSTALL_DIR)$(INSTALL_PREFIX)/$${file} \
	      ;; \
	  esac ; \
	done

all: install fix_shebang_python_module

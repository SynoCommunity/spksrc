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
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build_ext -I $(STAGING_INSTALL_PREFIX)/include -L $(STAGING_INSTALL_PREFIX)/lib $(BUILD_ARGS)

install_python_module:
	@$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR) --prefix $(INSTALL_PREFIX) $(INSTALL_ARGS)

fix_shebang_python_module:
	@cat PLIST | sed 's/:/ /' | while read type file ; do \
	  for script in $(INSTALL_DIR)$(INSTALL_PREFIX)/$${file} ; do \
	    if file $${script} | grep -iq "python script" ; then \
	        echo -n "Fixing shebang for $${script} ... " ; \
	        sed -i -e '1 s|^#!.*$$|#!$(PYTHON_INTERPRETER)|g' $${script} > /dev/null 2>&1 && echo "ok" || echo "failed!" ; \
	    fi ; \
	  done ; \
	done

all: install fix_shebang_python_module


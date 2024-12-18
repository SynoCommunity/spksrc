### Python module rules
#   Invoke make to (cross-) compile a python extension module. 
# You can do some customization through python-cc.mk

# Python module targets
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = nop
endif
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = compile_python_module
endif
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_python_module
endif

# Resume with standard spksrc.cross-cc.mk
include ../../mk/spksrc.cross-cc.mk

# Define where is located the crossenv
CROSSENV_MODULE_PATH = $(firstword $(wildcard $(WORK_DIR)/crossenv-$(PKG_NAME)-$(PKG_VERS) $(WORK_DIR)/crossenv-$(PKG_NAME) $(WORK_DIR)/crossenv-default))

### Prepare crossenv
build_crossenv_module:
	@$(MSG) WHEEL="$(PKG_NAME)-$(PKG_VERS)" $(MAKE) crossenv-$(ARCH)-$(TCVERSION)
	-@MAKEFLAGS= WHEEL="$(PKG_NAME)-$(PKG_VERS)" $(MAKE) crossenv-$(ARCH)-$(TCVERSION)

### Python extension module rules
compile_python_module: build_crossenv_module
	$(foreach e,$(shell cat $(CROSSENV_MODULE_PATH)/build/python-cc.mk),$(eval $(e)))
	$(eval PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/)
	@$(MSG) "PYTHON MODULE: activate crossenv found: $(CROSSENV)"
	@. $(CROSSENV) ; \
	$(RUN) PYTHONPATH=$(PYTHONPATH) python setup.py build_ext \
	       -I $(STAGING_INSTALL_PREFIX)/include \
	       -L $(STAGING_INSTALL_PREFIX)/lib $(BUILD_ARGS)

install_python_module:
	@. $(CROSSENV) ; \
	$(RUN) PYTHONPATH=$(PYTHONPATH) python setup.py install \
	       --root $(INSTALL_DIR) \
	       --prefix $(INSTALL_PREFIX) $(INSTALL_ARGS)

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

###

# Allow generating per-wheel crossenv
include ../../mk/spksrc.crossenv.mk

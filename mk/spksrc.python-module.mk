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
prepare_crossenv:
	@$(MSG) $(MAKE) WHEEL_NAME=\"$(PKG_NAME)\" WHEEL_VERSION=\"$(PKG_VERS)\" crossenv-$(ARCH)-$(TCVERSION)
	@MAKEFLAGS= $(MAKE) WHEEL_NAME="$(PKG_NAME)" WHEEL_VERSION="$(PKG_VERS)" crossenv-$(ARCH)-$(TCVERSION) --no-print-directory

### Python extension module rules
compile_python_module: prepare_crossenv
	$(foreach e,$(shell cat $(CROSSENV_MODULE_PATH)/build/python-cc.mk),$(eval $(e)))
	$(eval PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/)
	@if [ -d "$(CROSSENV_PATH)" ] ; then \
	   PATH=$(call dedup, $(call merge, $(ENV), PATH, :), :):$(PYTHON_NATIVE_PATH):$(CROSSENV_PATH)/bin:$${PATH} ; \
	   $(MSG) "crossenv: [$(CROSSENV_PATH)]" ; \
	   $(MSG) "pip: [$$(which cross-pip)]" ; \
	   $(MSG) "maturin: [$$(which maturin)]" ; \
	else \
	   echo "ERROR: crossenv not found!" ; \
	   exit 2 ; \
	fi ; \
	$(MSG) PYTHONPATH=$(PYTHONPATH) cross-python3 setup.py build_ext \
	       -I $(STAGING_INSTALL_PREFIX)/include \
	       -L $(STAGING_INSTALL_PREFIX)/lib $(BUILD_ARGS) ; \
	$(RUN) PYTHONPATH=$(PYTHONPATH) cross-python3 setup.py build_ext \
	       -I $(STAGING_INSTALL_PREFIX)/include \
	       -L $(STAGING_INSTALL_PREFIX)/lib $(BUILD_ARGS)

install_python_module:
	@PATH=$(call dedup, $(call merge, $(ENV), PATH, :), :):$(PYTHON_NATIVE_PATH):$(CROSSENV_PATH)/bin:$${PATH} ; \
	$(MSG) PYTHONPATH=$(PYTHONPATH) cross-python3 setup.py install \
	       --root $(INSTALL_DIR) \
	       --prefix $(INSTALL_PREFIX) $(INSTALL_ARGS) ; \
	$(RUN) PYTHONPATH=$(PYTHONPATH) cross-python3 setup.py install \
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

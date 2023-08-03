###
### Reuse Python libraries
###
# Variables:
#  PYTHON_PACKAGE       Must be set to the python spk folder (python310, python311, ...)

# set default spk/python* path to use
PYTHON_PACKAGE_ROOT = $(realpath $(shell pwd)/../$(PYTHON_PACKAGE)/work-$(ARCH)-$(TCVERSION))
export PYTHON_PREFIX = $(realpath $(PYTHON_PACKAGE_ROOT)/install/var/packages/$(PYTHON_PACKAGE)/target)
export OPENSSL_PREFIX = $(PYTHON_PREFIX)

# get PYTHON_VERSION and other variables
-include $(PYTHON_PACKAGE_ROOT)/python-cc.mk

ifneq ($(wildcard $(PYTHON_PREFIX)),)
# set ld flags to rewrite for the library path used to access
# libraries provided by the python package at destination
export ADDITIONAL_LDFLAGS += -Wl,--rpath-link,$(PYTHON_PREFIX)/lib -Wl,--rpath,/var/packages/$(PYTHON_PACKAGE)/target/lib

# set PYTHONPATH for spksrc.python-module.mk
PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(PYTHON_PREFIX)/lib/python$(PYTHON_VERSION)/site-packages/

# Re-use all default python mandatory libraries
PYTHON_LIBS := $(wildcard $(PYTHON_PREFIX)/lib/pkgconfig/*.pc)

# Re-use all python dependencies and mark as already done
PYTHON_DEPENDS := $(foreach cross,$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $(PYTHON_PACKAGE_ROOT)/../) 2>/dev/null | grep ^$(PYTHON_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(shell pwd)/../../$(pkg_name)/Makefile))),$(wildcard $(PYTHON_PACKAGE_ROOT)/.$(cross)-*_done))

# call-up pre-depend to prepare the shared python build environment
PRE_DEPEND_TARGET = python_pre_depend

else
BUILD_DEPENDS += cross/$(PYTHON_PACKAGE)
endif

include ../../mk/spksrc.spk.mk

.PHONY: python_pre_depend
python_pre_depend:
	@$(MSG) *****************************************************
	@$(MSG) *** Use existing shared objects from python $(PYTHON_VERSION)
	@$(MSG) *** PATH: $(PYTHON_PACKAGE_ROOT)
	@$(MSG) *****************************************************
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(PYTHON_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@ln -sf $(PYTHON_PACKAGE_ROOT)/crossenv $(WORK_DIR)/crossenv
	@ln -sf $(PYTHON_PACKAGE_ROOT)/python-cc.mk $(WORK_DIR)/python-cc.mk
	@$(foreach _done,$(PYTHON_DEPENDS), ln -sf $(_done) $(WORK_DIR) ;)
	# EXCEPTIONS: Ensure zlib,bzip2 is always built locally
	@rm -f $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/zlib.pc $(WORK_DIR)/.zlib*
	@rm -f $(WORK_DIR)/.bzip2*

###
### Reuse Python libraries
###
# Variables:
#  PYTHON_PACKAGE       Must be set to the python spk folder (python310, python311, ...)

# set default spk/python* path to use
PYTHON_PACKAGE_ROOT = $(realpath $(shell pwd)/../$(PYTHON_PACKAGE)/work-$(ARCH)-$(TCVERSION))

ifneq ($(wildcard $(PYTHON_PACKAGE_ROOT)),)

# set ld flags to rewrite for the library path used to access
# python libraries provided by the python package at destination
ifeq ($(strip $(PYTHON_STAGING_PREFIX)),)
export PYTHON_PREFIX = /var/packages/$(PYTHON_PACKAGE)/target
export PYTHON_STAGING_PREFIX = $(realpath $(PYTHON_PACKAGE_ROOT)/install/$(PYTHON_PREFIX))
export ADDITIONAL_LDFLAGS += -Wl,--rpath-link,$(PYTHON_STAGING_PREFIX)/lib -Wl,--rpath,$(PYTHON_PREFIX)/lib
endif

ifeq ($(strip $(OPENSSL_STAGING_PREFIX)),)
export OPENSSL_PREFIX = $(PYTHON_PREFIX)
export OPENSSL_STAGING_PREFIX = $(PYTHON_STAGING_PREFIX)
else
export ADDITIONAL_LDFLAGS += -Wl,--rpath-link,$(OPENSSL_STAGING_PREFIX)/lib -Wl,--rpath,$(OPENSSL_PREFIX)/lib
endif

# get PYTHON_VERSION and other variables
-include $(PYTHON_PACKAGE_ROOT)/python-cc.mk

# set PYTHONPATH for spksrc.python-module.mk
PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(PYTHON_STAGING_PREFIX)/lib/python$(PYTHON_VERSION)/site-packages/

# Re-use all default python mandatory libraries
PYTHON_LIBS := $(wildcard $(PYTHON_STAGING_PREFIX)/lib/pkgconfig/*.pc)

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

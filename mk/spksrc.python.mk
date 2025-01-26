###
### Reuse Python libraries
###
# Variables:
#  PYTHON_PACKAGE       Must be set to the python spk folder (python310, python311, ...)

# set default spk/python* path to use
PYTHON_PACKAGE_WORK_DIR = $(realpath $(CURDIR)/../../spk/$(PYTHON_PACKAGE)/work-$(ARCH)-$(TCVERSION))

include ../../mk/spksrc.common.mk

# armv5 no longer supported with python >= 3.12
ifeq ($(call version_ge, $(subst python,,$(PYTHON_PACKAGE)), 312), 1)
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)
endif

ifneq ($(wildcard $(PYTHON_PACKAGE_WORK_DIR)),)

# Export variables so to be usable in crossenv and cross/*
export PYTHON_PACKAGE
export PYTHON_PACKAGE_WORK_DIR
export SPK_NAME

# Set Python installtion prefix directory variables
ifeq ($(strip $(PYTHON_STAGING_INSTALL_PREFIX)),)
export PYTHON_PREFIX = /var/packages/$(PYTHON_PACKAGE)/target
export PYTHON_STAGING_INSTALL_PREFIX = $(realpath $(PYTHON_PACKAGE_WORK_DIR)/install/$(PYTHON_PREFIX))
endif

# Set OpenSSL installtion prefix directory variables
ifeq ($(strip $(OPENSSL_STAGING_PREFIX)),)
export OPENSSL_PREFIX = $(PYTHON_PREFIX)
export OPENSSL_STAGING_PREFIX = $(PYTHON_STAGING_INSTALL_PREFIX)
endif

# set build flags including ld to rewrite for the library path
# used to access python package provide libraries at destination
export ADDITIONAL_CFLAGS   += -I$(PYTHON_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$(PYTHON_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$(PYTHON_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$(PYTHON_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(PYTHON_STAGING_INSTALL_PREFIX)/lib -Wl,--rpath,$(PYTHON_PREFIX)/lib

# similarly, ld to rewrite OpenSSL library path if differs
ifneq ($(OPENSSL_STAGING_PREFIX),$(PYTHON_STAGING_INSTALL_PREFIX))
export ADDITIONAL_LDFLAGS  += -L$(OPENSSL_STAGING_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(OPENSSL_STAGING_PREFIX)/lib -Wl,--rpath,$(OPENSSL_PREFIX)/lib
endif

# Re-use all default python mandatory libraries (with exception of bzip2, xz, zlib)
PYTHON_LIBS_EXCLUDE = %bzip2.pc %lzma.pc %zlib.pc
PYTHON_LIBS := $(filter-out $(PYTHON_LIBS_EXCLUDE),$(wildcard $(PYTHON_STAGING_INSTALL_PREFIX)/lib/pkgconfig/*.pc))

# Re-use all python dependencies and mark as already done (with exceltion of bzip2, xz, zlib)
PYTHON_DEPENDS_EXCLUDE = bzip2 xz zlib
PYTHON_DEPENDS := $(foreach cross,$(filter-out $(PYTHON_DEPENDS_EXCLUDE),$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $(PYTHON_PACKAGE_WORK_DIR)/../) 2>/dev/null | grep ^$(PYTHON_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile)))),$(wildcard $(PYTHON_PACKAGE_WORK_DIR)/.$(cross)-*_done))

# call-up pre-depend to prepare the shared python build environment
PRE_DEPEND_TARGET = python_pre_depend

else
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
BUILD_DEPENDS += cross/$(PYTHON_PACKAGE)
endif
endif

include ../../mk/spksrc.spk.mk

.PHONY: python_pre_depend
python_pre_depend:
	@$(MSG) "*****************************************************"
	@$(MSG) "*** Use existing shared objects from python $(PYTHON_VERSION)"
	@$(MSG) "*** PATH: $(PYTHON_PACKAGE_WORK_DIR)"
	@$(MSG) "*****************************************************"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(PYTHON_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$(PYTHON_DEPENDS), ln -sf $(_done) $(WORK_DIR) ;)
	@# EXCEPTION: Do not symlink cross/* wheel builds
	@make --no-print-directory dependency-flat | sort -u | grep cross/ | while read depend ; do \
	   makefile="../../$${depend}/Makefile" ; \
	   if grep -q spksrc.python-wheel.mk $${makefile} ; then \
	      pkgstr=$$(grep ^PKG_NAME $${makefile}) ; \
	      pkgname=$$(echo $${pkgstr#*=} | xargs) ; \
	      find $(WORK_DIR)/$${pkgname}* $(WORK_DIR)/.$${pkgname}* -maxdepth 0 -type l -exec rm -fr {} \; 2>/dev/null || true ; \
	   fi ; \
	done

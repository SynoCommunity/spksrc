
ifndef SPKSRC_SPK_BASE_MK
SPKSRC_SPK_BASE_MK := 1

define SPK_BASE_TEMPLATE

# $(1)_PACKAGE_WORK_DIR exists
ifneq ($(wildcard $($(1)_PACKAGE_WORK_DIR)),)

# Define excluded library list
EXCLUDED_LIBS = %bzip2.pc %lzma.pc %zlib.pc
EXCLUDED_NAME = bzip2 xz zlib

# Set and export ffmpeg|python|videodriver installation prefix directory variables
ifeq ($(strip $($(1)_STAGING_INSTALL_PREFIX)),)
$(eval export $(1)_INSTALL_PREFIX = /var/packages/$($(1)_PACKAGE)/target)
$(eval export $(1)_STAGING_INSTALL_PREFIX = $(realpath $($(1)_PACKAGE_WORK_DIR)/install/$($(1)_INSTALL_PREFIX)))
endif

# set build flags including ld to rewrite for the library path
# used to access ffmpeg|python|videodriver package provide libraries at destination
ifneq ($(wildcard $($(1)_STAGING_INSTALL_PREFIX)),)

export ADDITIONAL_CFLAGS   += -I$($(1)_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$($(1)_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$($(1)_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$($(1)_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$($(1)_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath,$($(1)_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-L$($(1)_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$($(1)_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath,$($(1)_INSTALL_PREFIX)/lib

# If no $(1)_PC specified then re-use all PKS_CONFIG libraries (with exception of excludes)
$(eval $(1)_LIBS_DEFAULT := $(filter-out $(EXCLUDED_LIBS),$(wildcard $($(1)_STAGING_INSTALL_PREFIX)/lib/pkgconfig/*.pc)))
$(eval $(1)_LIBS := $(if $(strip $($(1)_PC)),$(wildcard $(addprefix $($(1)_STAGING_INSTALL_PREFIX)/lib/pkgconfig/,$($(1)_PC))),$($(1)_LIBS_DEFAULT)))

# Generate current package fulldependency list excluding one related to ffmpeg|python|videodriver
$(eval $(1)_DEPENDS_FILTERED := $(sort $(shell $(MAKE) -s dependency-list EXCLUDE_DEPENDS="$(META_DEPENDS)" | cut -f2 -d:)))

# From EXCLUDED_NAME list of exluded dependencies, keep direct dependencies to current package build
$(eval $(1)_DIRECT_DEPENDS := $(filter $(addprefix cross/,$(EXCLUDED_NAME)),$($(1)_DEPENDS_FILTERED)))

# Define resulting dependency list
DEPENDS := $($(1)_DIRECT_DEPENDS) $(DEPENDS)

# Assign SPK package depdendencies
SPK_DEPENDS := $(if $(strip $(SPK_DEPENDS)),$($(1)_PACKAGE):$(SPK_DEPENDS),$($(1)_PACKAGE))

# If no PKG_CONFIG definintion passed ($(1)_PC), mark all ffmpeg|python|videodriver
# dependencies as already done with exception of excluded library list: bzip2, xz, zlib
$(eval $(1)_STATUS_COOKIES := $(if $(strip $($(1)_PC)),,$(foreach cross,$(filter-out $(EXCLUDED_NAME),$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $($(1)_PACKAGE_WORK_DIR)/../) 2>/dev/null | grep ^$($(1)_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile)))),$(wildcard $($(1)_PACKAGE_WORK_DIR)/.$(cross)-*_done))))

# call-up pre-depend to prepare the shared ffmpeg|python|videodriver build environment
PRE_DEPEND_TARGET += $(1)_meta_pre_depend

# end ifeq $(1)_STAGING_INSTALL_PREFIX
endif

# No pre-built ffmpeg|python|videodriver available, inject dependencies
else
DEPENDS := $($(1)_DEPENDS) $(DEPENDS)

# end ifeq $(1)_PACKAGE_WORK_DIR
endif

.PHONY: $(1)_meta_pre_depend
$(1)_meta_pre_depend: $(1)_meta $(1)_links

.PHONY: $(1)_msg
$(1)_msg:
	@$(MSG) "*********************************************************************"
	@$(MSG) "*** Use existing shared objects from [$($(1)_PACKAGE)]"
	@$(MSG) "*** PATH: $($(1)_PACKAGE_WORK_DIR)"
	@$(MSG) "*** DEPENDS: $(DEPENDS)"
	@$(MSG) "*** $(1)_STATUS_COOKIES: $($(1)_STATUS_COOKIES)"
	@$(MSG) "*********************************************************************"

.PHONY: $(1)_links
$(1)_links: $(1)_msg
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$($(1)_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$($(1)_STATUS_COOKIES),ln -sf $(_done) $(WORK_DIR) ;)

endef

endif # ifndef SPKSRC_SPK_BASE_MK

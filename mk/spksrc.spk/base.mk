ifndef SPKSRC_SPK_BASE_MK
SPKSRC_SPK_BASE_MK := 1

# -------------------------------------------------------------------
# SPK_BASE_TEMPLATE
#
# Called by ffmpeg.mk, videodriver.mk, python.mk etc. via:
#   $(eval $(call SPK_BASE_TEMPLATE,NAMESPACE))
#
# Assumes caller has already verified $(NAMESPACE_PACKAGE_WORK_DIR)
# exists before calling — the ifeq guard lives in the caller:
#
#   ifneq ($(wildcard $(FFMPEG_PACKAGE_WORK_DIR)),)
#     $(eval $(call SPK_BASE_TEMPLATE,FFMPEG))
#   else
#     DEPENDS := $(FFMPEG_DEPENDS) $(DEPENDS)
#   endif
# -------------------------------------------------------------------
define SPK_BASE_TEMPLATE

# Define excluded library / package list
EXCLUDED_LIBS = %bzip2.pc %lzma.pc %zlib.pc
EXCLUDED_NAME = bzip2 xz zlib

# Set installation prefix variables for this namespace
$(eval $(1)_INSTALL_PREFIX         := /var/packages/$($(1)_PACKAGE)/target)
$(eval $(1)_STAGING_INSTALL_PREFIX := $(realpath $($(1)_PACKAGE_WORK_DIR)/install/$($(1)_INSTALL_PREFIX)))
$(eval export $(1)_INSTALL_PREFIX)
$(eval export $(1)_STAGING_INSTALL_PREFIX)

# Set build flags so the package can find headers and libs at compile time,
# and the dynamic linker will find them at runtime on the NAS.
$(eval ADDITIONAL_CFLAGS    += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-I$($(1)_STAGING_INSTALL_PREFIX)/include,))
$(eval ADDITIONAL_CPPFLAGS  += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-I$($(1)_STAGING_INSTALL_PREFIX)/include,))
$(eval ADDITIONAL_CXXFLAGS  += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-I$($(1)_STAGING_INSTALL_PREFIX)/include,))
$(eval ADDITIONAL_LDFLAGS   += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-L$($(1)_STAGING_INSTALL_PREFIX)/lib,))
$(eval ADDITIONAL_LDFLAGS   += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-Wl$(,)--rpath-link$(,)$($(1)_STAGING_INSTALL_PREFIX)/lib,))
$(eval ADDITIONAL_LDFLAGS   += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-Wl$(,)--rpath$(,)$($(1)_INSTALL_PREFIX)/lib,))
$(eval ADDITIONAL_RUSTFLAGS += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-Clink-arg=-L$($(1)_STAGING_INSTALL_PREFIX)/lib,))
$(eval ADDITIONAL_RUSTFLAGS += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-Clink-arg=-Wl$(,)--rpath-link$(,)$($(1)_STAGING_INSTALL_PREFIX)/lib,))
$(eval ADDITIONAL_RUSTFLAGS += $(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)),-Clink-arg=-Wl$(,)--rpath$(,)$($(1)_INSTALL_PREFIX)/lib,))
$(eval export ADDITIONAL_CFLAGS)
$(eval export ADDITIONAL_CPPFLAGS)
$(eval export ADDITIONAL_CXXFLAGS)
$(eval export ADDITIONAL_LDFLAGS)
$(eval export ADDITIONAL_RUSTFLAGS)

# Set OpenSSL prefix if this package provides libssl (and not already set)
$(eval OPENSSL_INSTALL_PREFIX         := $(if $(strip $(OPENSSL_INSTALL_PREFIX)),$(OPENSSL_INSTALL_PREFIX),$(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)/lib/libssl.so),$($(1)_INSTALL_PREFIX),)))
$(eval OPENSSL_STAGING_INSTALL_PREFIX := $(if $(strip $(OPENSSL_STAGING_INSTALL_PREFIX)),$(OPENSSL_STAGING_INSTALL_PREFIX),$(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)/lib/libssl.so),$($(1)_STAGING_INSTALL_PREFIX),)))
$(eval export OPENSSL_INSTALL_PREFIX)
$(eval export OPENSSL_STAGING_INSTALL_PREFIX)

# Build the list of pkg-config files to symlink:
#   - if $(1)_PC is set, use only those specific .pc files
#   - otherwise use all .pc files (minus excludes)
#   - using realpath for real destination to avoid symlink -> symlink
$(eval $(1)_LIBS_DEFAULT := $(filter-out $(EXCLUDED_LIBS),$(foreach f,$(wildcard $($(1)_STAGING_INSTALL_PREFIX)/lib/pkgconfig/*.pc),$(realpath $(f)))))
$(eval $(1)_LIBS := $(if $(strip $($(1)_PC)),$(foreach f,$(wildcard $(addprefix $($(1)_STAGING_INSTALL_PREFIX)/lib/pkgconfig/,$($(1)_PC))),$(realpath $(f))),$($(1)_LIBS_DEFAULT)))

# Generate filtered dependency list (exclude all meta package deps)
$(eval $(1)_DEPENDS_FILTERED := $(sort $(shell $(MAKE) -s dependency-list EXCLUDE_DEPENDS="$(META_DEPENDS)" | cut -f2 -d:)))

# From EXCLUDED_NAME, keep only those that are direct deps of this package
$(eval $(1)_DIRECT_DEPENDS := $(filter $(addprefix cross/,$(EXCLUDED_NAME)),$($(1)_DEPENDS_FILTERED)))

# Inject direct deps into the package DEPENDS list
$(eval DEPENDS := $($(1)_DIRECT_DEPENDS) $(DEPENDS))

# Register this meta package as an SPK dependency (no duplicates)
$(eval SPK_DEPENDS := $(call dedup,$($(1)_PACKAGE):$(SPK_DEPENDS),:))

# Build list of status cookies to symlink (skip if $(1)_PC is set)
$(eval $(1)_STATUS_COOKIES := $(if $(strip $($(1)_PC)),,$(foreach cross,$(filter-out $(EXCLUDED_NAME),$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $($(1)_PACKAGE_WORK_DIR)/../) 2>/dev/null | grep ^$($(1)_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile)))),$(wildcard $($(1)_PACKAGE_WORK_DIR)/.$(cross)-*_done))))

# Register pre-depend hook so _links runs before dependency compilation
$(eval PRE_DEPEND_TARGET += $(1)_meta_pre_depend)

.PHONY: $(1)_meta_pre_depend
$(1)_meta_pre_depend: $(1)_meta $(1)_links

.PHONY: $(1)_msg
$(1)_msg:
	@$(MSG) "*********************************************************************"
	@$(MSG) "*** Use existing shared objects from [$($(1)_PACKAGE)]"
	@$(MSG) "*** PATH: $($(1)_PACKAGE_WORK_DIR)"
ifneq ($(OPENSSL_INSTALL_PREFIX),)
	@$(MSG) "*** libssl.so: $(wildcard $($(1)_STAGING_INSTALL_PREFIX)/lib/libssl.so)"
endif
	@$(MSG) "*** DEPENDS: $(DEPENDS)"
	@$(MSG) "*** SPK_DEPENDS: $(SPK_DEPENDS)"
	@$(MSG)
	@$(MSG) "*** OPENSSL_INSTALL_PREFIX: $(OPENSSL_INSTALL_PREFIX)"
	@$(MSG) "*** OPENSSL_STAGING_INSTALL_PREFIX: $(OPENSSL_STAGING_INSTALL_PREFIX)"
	@$(MSG) "*** ADDITIONAL_LDFLAGS: $(ADDITIONAL_LDFLAGS)"
	@$(MSG) "*** ADDITIONAL_RUSTFLAGS: $(ADDITIONAL_RUSTFLAGS)"
	@$(MSG) "*** $(1)_DIRECT_DEPENDS: $($(1)_DIRECT_DEPENDS)"
	@$(MSG) "*** $(1)_DEPENDS_FILTERED: $($(1)_DEPENDS_FILTERED)"
	@$(MSG) "*********************************************************************"

.PHONY: $(1)_links
$(1)_links: $(1)_msg
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$($(1)_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$($(1)_STATUS_COOKIES),ln -sf $(_done) $(WORK_DIR) ;)

endef

endif # ifndef SPKSRC_SPK_BASE_MK

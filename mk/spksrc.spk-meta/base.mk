###############################################################################
# spksrc.spk-meta/base.mk
#
# SPK_BASE_TEMPLATE: wires a meta package's staging into the consumer SPK
# (shared build-skip status cookies, environment and dependency hooks).
###############################################################################

ifndef SPKSRC_SPK_BASE_MK
SPKSRC_SPK_BASE_MK := 1

# TC_VARS_META_MK file-target (generates the inspectable tc_vars.meta.mk),
# used by the $(1)_meta_pre_depend hook below.
include ../../mk/spksrc.spk-meta/meta.mk

# Low-level libs kept out of the meta build-skip status-cookie sharing so a
# consumer can build its own copy when it declares the dependency.
EXCLUDED_NAME = bzip2 xz zlib

# Operator used to pin the meta package version in install_dep_packages.
# Backslash-escaped: the INFO recipe echoes SPK_DEPENDS unquoted at shell
# level (the surrounding \" are literal characters), so a bare > would
# redirect. One escaping level only — this value stays within make.
META_DEP_OP ?= \>\=

# Helpers to rebuild a colon-separated SPK_DEPENDS from a word list
META_EMPTY :=
META_SPACE := $(META_EMPTY) $(META_EMPTY)

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

# Set installation prefix variables for this namespace
$(eval $(1)_INSTALL_PREFIX         := /var/packages/$($(1)_PACKAGE)/target)
$(eval $(1)_STAGING_INSTALL_PREFIX := $(realpath $($(1)_PACKAGE_WORK_DIR)/install/$($(1)_INSTALL_PREFIX)))
# Version of the meta package itself, read from its own spk Makefile
# ($(SPK_VERS)/$(SPK_REV) at this point belong to the consumer package)
$(eval $(1)_SPK_MAKEFILE           := $(realpath $($(1)_PACKAGE_WORK_DIR)/..)/Makefile)
$(eval $(1)_VERSION                := $(shell sed -n 's/^SPK_VERS[[:space:]]*=[[:space:]]*//p' $($(1)_SPK_MAKEFILE))-$(shell sed -n 's/^SPK_REV[[:space:]]*=[[:space:]]*//p' $($(1)_SPK_MAKEFILE)))
$(eval export $(1)_INSTALL_PREFIX)
$(eval export $(1)_STAGING_INSTALL_PREFIX)

# Accumulate this meta's pkgconfig dir (add-if-absent); exported so cross/
# sub-makes (which don't re-run SPK_BASE_TEMPLATE) inherit it and build the
# ordered PKG_CONFIG_LIBDIR from it (cross-env.mk).
$(eval META_PKG_CONFIG_LIBDIR := $(META_PKG_CONFIG_LIBDIR) $(filter-out $(META_PKG_CONFIG_LIBDIR),$(if $(wildcard $($(1)_STAGING_INSTALL_PREFIX)/lib/pkgconfig),$($(1)_STAGING_INSTALL_PREFIX)/lib/pkgconfig,)))
$(eval export META_PKG_CONFIG_LIBDIR)

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

# Generate filtered dependency list (exclude all meta package deps)
$(eval $(1)_DEPENDS_FILTERED := $(sort $(shell $(MAKE) -s ARCH=$(ARCH) TCVERSION=$(TCVERSION) dependency-list EXCLUDE_DEPENDS="$(META_DEPENDS)" | cut -f2 -d:)))

# From EXCLUDED_NAME, keep only those that are direct deps of this package
$(eval $(1)_DIRECT_DEPENDS := $(filter $(addprefix cross/,$(EXCLUDED_NAME)),$($(1)_DEPENDS_FILTERED)))

# Inject direct deps into the package DEPENDS list
$(eval DEPENDS := $(call uniq,$($(1)_DIRECT_DEPENDS) $(DEPENDS)))

# Register this meta package as a version-pinned SPK dependency:
#  - an entry that already carries an explicit version constraint
#    (e.g. python314>=3.14.5-4) is left untouched;
#  - a bare entry (e.g. "ffmpeg8" from the consumer Makefile) is replaced
#    by the pinned one;
#  - SPK_DEPENDS is rebuilt unquoted so the INFO quoting stays well-formed.
# Skipped when the meta is only an indirect dependency (see $(1)_INDIRECT,
# e.g. videodriver pulled in through the ffmpeg rpath): the direct meta
# carries the pin, DSM resolves the chain transitively.
$(eval $(1)_SPK_DEP_LIST := $(subst :, ,$(subst ",,$(SPK_DEPENDS))))
$(if $($(1)_INDIRECT)$(filter $($(1)_PACKAGE)=% $($(1)_PACKAGE)<% $($(1)_PACKAGE)>%,$($(1)_SPK_DEP_LIST)),,$(eval SPK_DEPENDS := $(subst $(META_SPACE),:,$(strip $($(1)_PACKAGE)$(META_DEP_OP)$($(1)_VERSION) $(filter-out $($(1)_PACKAGE),$($(1)_SPK_DEP_LIST))))))

# Build list of status cookies to symlink
$(eval $(1)_STATUS_COOKIES := $(sort $(foreach cross,$(filter-out $(EXCLUDED_NAME),$(foreach pkg_name,$(shell $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) dependency-list -C $(realpath $($(1)_PACKAGE_WORK_DIR)/../) 2>/dev/null | grep ^$($(1)_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile)))),$(wildcard $($(1)_PACKAGE_WORK_DIR)/.$(cross)-*_done))))

# Register pre-depend hook so _links runs before dependency compilation
$(eval PRE_DEPEND_TARGET += $(1)_meta_pre_depend)

.PHONY: $(1)_meta_pre_depend
$(1)_meta_pre_depend: $(1)_links $(1)_meta $(TC_VARS_META_MK)

.PHONY: $(1)_msg
$(1)_msg:
	@$(MSG) "*********************************************************************"
	@$(MSG) "*** Use existing shared objects from [$($(1)_PACKAGE)]"
	@$(MSG) "*** PATH: $($(1)_PACKAGE_WORK_DIR)"
	@$(MSG) "*********************************************************************"

# Symlink the meta's dependency build-status cookies so the consumer skips
# rebuilding what the meta already built (build-level sharing).
.PHONY: $(1)_links
$(1)_links: $(1)_msg
	@$(foreach _done,$($(1)_STATUS_COOKIES),ln -sf $(_done) $(WORK_DIR) ;)

endef

endif # ifndef SPKSRC_SPK_BASE_MK

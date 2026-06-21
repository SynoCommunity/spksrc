ifndef SPKSRC_SPK_META_MK
SPKSRC_SPK_META_MK := 1

# Materialize the meta cross-dependency environment into an inspectable
# artifact (tc_vars.meta.mk, cleaned by spkclean's tc_vars*.mk glob).
#
# This lives here rather than in the toolchain tc_vars generation
# (spksrc.toolchain/) on purpose: unlike the toolchain tc_vars.* files (which
# describe the toolchain identity and are generated once at stage1, in the
# toolchain context), this one depends on the CONSUMER's meta graph
# (META_PKGCONFIG_DIRS, openssl prefix, flags) accumulated by SPK_BASE_TEMPLATE,
# so it can only be generated in the consumer context.
#
# Output-only for now: the live variables (accumulator + cross-env.mk) drive the
# build; this file is for `cat` inspection and to replace the opacity of the
# scattered $(eval export). Shared across namespaces (not $(1)-prefixed); written
# once with the fully accumulated environment. Wired in via the
# $(1)_meta_pre_depend hook in spksrc.spk/base.mk.
.PHONY: meta_env
meta_env:
	@mkdir -p $(WORK_DIR)
	@echo "# Generated meta cross-dependency environment - $(NAME)"          > $(WORK_DIR)/tc_vars.meta.mk
	@echo "META_PKGCONFIG_DIRS := $(strip $(META_PKGCONFIG_DIRS))"          >> $(WORK_DIR)/tc_vars.meta.mk
	@echo "PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR)"                       >> $(WORK_DIR)/tc_vars.meta.mk
	@echo "ADDITIONAL_CFLAGS += $(ADDITIONAL_CFLAGS)"                       >> $(WORK_DIR)/tc_vars.meta.mk
	@echo "ADDITIONAL_LDFLAGS += $(ADDITIONAL_LDFLAGS)"                     >> $(WORK_DIR)/tc_vars.meta.mk
	@echo "OPENSSL_STAGING_INSTALL_PREFIX := $(OPENSSL_STAGING_INSTALL_PREFIX)" >> $(WORK_DIR)/tc_vars.meta.mk

endif # ifndef SPKSRC_SPK_META_MK

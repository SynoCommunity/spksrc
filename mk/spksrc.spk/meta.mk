ifndef SPKSRC_SPK_META_MK
SPKSRC_SPK_META_MK := 1

# Materialize the meta cross-dependency environment into an inspectable
# artifact (tc_vars.meta.mk, cleaned by spkclean's tc_vars*.mk glob).
#
# Placement (spksrc.spk/ vs spksrc.toolchain/): this lives under spksrc.spk/ on
# purpose. The toolchain tc_vars.* files describe the toolchain identity, are
# generated once per arch at stage1, and their generator
# (spksrc.toolchain/tc_vars.mk) is included ONLY by spksrc.toolchain.mk - it is
# absent from the consumer/cross include graph (cross-cc.mk -> cross-env.mk only
# READS the generated tc_vars). This artifact instead depends on the CONSUMER's
# meta graph (META_PKGCONFIG_DIRS, openssl prefix, flags) accumulated by
# SPK_BASE_TEMPLATE, which only exists at spk-stage2. So the recipe must live in
# a file reachable from the consumer graph (base.mk -> here); the toolchain
# generator cannot host it.
#
# It adopts the toolchain tc_vars file-target pattern (a named TC_VARS_META_MK
# output + a real, cached file rule like make_tc_var_rule) rather than a .PHONY
# that rewrites on every depend - same idempotent "generate once per WORK_DIR,
# regenerated after a clean" semantics as the other tc_vars.* files.
#
# Output-only: the live variables (the SPK_BASE_TEMPLATE accumulator +
# cross-env.mk) drive the build; this file is never -included - it exists for
# `cat` inspection and to replace the opacity of the scattered $(eval export).
# Shared across namespaces (not $(1)-prefixed); written once with the fully
# accumulated environment. Wired in via the $(1)_meta_pre_depend hook in
# spksrc.spk/base.mk.

# Inspectable meta env artifact, named like the toolchain tc_vars.* family so
# spkclean's tc_vars*.mk glob removes it (recursive '=' - WORK_DIR resolves lazily).
TC_VARS_META_MK = $(WORK_DIR)/tc_vars.meta.mk

# Cached file-target modeled on spksrc.toolchain/tc_vars.mk's make_tc_var_rule.
# The content is fully expandable at parse time in the consumer context, so it
# is emitted directly (no submake indirection needed, unlike the toolchain).
$(TC_VARS_META_MK):
	@$(MSG) "Generating $(TC_VARS_META_MK)"
	@mkdir -p $(WORK_DIR)
	@echo "# Generated meta cross-dependency environment - $(NAME)"              > $@
	@echo "META_PKGCONFIG_DIRS := $(strip $(META_PKGCONFIG_DIRS))"              >> $@
	@echo "PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR)"                           >> $@
	@echo "ADDITIONAL_CFLAGS += $(ADDITIONAL_CFLAGS)"                           >> $@
	@echo "ADDITIONAL_LDFLAGS += $(ADDITIONAL_LDFLAGS)"                         >> $@
	@echo "OPENSSL_STAGING_INSTALL_PREFIX := $(OPENSSL_STAGING_INSTALL_PREFIX)" >> $@

# Convenience phony alias for direct invocation (`make meta_env`), mirroring the
# toolchain's grouped generate_tc_vars_* targets.
.PHONY: meta_env
meta_env: $(TC_VARS_META_MK)

endif # ifndef SPKSRC_SPK_META_MK

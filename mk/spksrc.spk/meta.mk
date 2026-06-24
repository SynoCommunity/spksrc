ifndef SPKSRC_SPK_META_MK
SPKSRC_SPK_META_MK := 1

# Inspectable diagnostic artifact (tc_vars.meta.mk, never -included) of the meta
# env accumulated by SPK_BASE_TEMPLATE. Under spksrc.spk/ (not toolchain/) as it
# depends on the per-consumer meta graph, known only at spk-stage2. Cached
# file-target named like tc_vars.* (cleaned by spkclean); meta_env is an alias.
TC_VARS_META_MK = $(WORK_DIR)/tc_vars.meta.mk

$(TC_VARS_META_MK):
	@$(MSG) "Generating $(TC_VARS_META_MK)"
	@mkdir -p $(WORK_DIR)
	@echo "# Generated meta cross-dependency environment - $(NAME)"              > $@
	@echo "META_PKGCONFIG_DIRS := $(strip $(META_PKGCONFIG_DIRS))"              >> $@
	@echo "PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR)"                           >> $@
	@echo "ADDITIONAL_CFLAGS += $(ADDITIONAL_CFLAGS)"                           >> $@
	@echo "ADDITIONAL_LDFLAGS += $(ADDITIONAL_LDFLAGS)"                         >> $@
	@echo "OPENSSL_STAGING_INSTALL_PREFIX := $(OPENSSL_STAGING_INSTALL_PREFIX)" >> $@

.PHONY: meta_env
meta_env: $(TC_VARS_META_MK)

endif # ifndef SPKSRC_SPK_META_MK

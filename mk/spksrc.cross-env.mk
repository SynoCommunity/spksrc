
PKG_CONFIG_LIBDIR = $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig

ENV  = env
ENV += PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR)
ENV += WORK_DIR=$(WORK_DIR)
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)

ifneq ($(TC),)
TC_VARS_MK = $(WORK_DIR)/tc_vars.mk

-include $(TC_VARS_MK)

$(TC_VARS_MK):
	$(create_target_dir)
	@$(MSG) "Set up toolchain "
	env $(MAKE) --no-print-directory -C ../../toolchains/$(TC)
	echo TC_ENV := `env $(MAKE) --no-print-directory -C ../../toolchains/$(TC) tc_env` > $@
	echo TC_CONFIGURE_ARGS := `env $(MAKE) --no-print-directory -C ../../toolchains/$(TC) tc_configure_args` >> $@

ENV += TC=$(TC)
ENV += $(TC_ENV)
endif

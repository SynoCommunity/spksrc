
PKG_CONFIG_LIBDIR = $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig

ENV += PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR)
ENV += WORK_DIR=$(WORK_DIR)
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)

ifneq ($(strip $(TC)),)
TC_VARS_MK = $(WORK_DIR)/tc_vars.mk

# These two variables are needed to build the CFLAGS and LDFLAGS env variables
export INSTALL_DIR
export INSTALL_PREFIX

$(TC_VARS_MK):
	$(create_target_dir)
	@$(MSG) "Set up toolchain "
	@if env $(MAKE) --no-print-directory -C ../../toolchains/$(TC) ; \
	then \
	  env $(MAKE) --no-print-directory -C ../../toolchains/$(TC) tc_vars > $@ ; \
	else \
	  echo "$$""(error An error occured while setting up the toolchain, please check the messages above)" > $@; \
	fi

-include $(TC_VARS_MK)
ENV += TC=$(TC)
ENV += $(TC_ENV)
endif


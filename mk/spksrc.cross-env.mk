PKG_CONFIG_LIBDIR = $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig

ENV += PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR)
ENV += WORK_DIR=$(WORK_DIR)
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)

ifeq ($(strip $(REQUIRE_KERNEL)),1)
ENV += KERNEL_ROOT=$(WORK_DIR)/../../../kernel/syno-$(ARCH)-$(TCVERSION)/work/source/linux
KERNEL_ROOT=$(WORK_DIR)/../../../kernel/syno-$(ARCH)-$(TCVERSION)/work/source/linux
endif

ifeq ($(strip $(REQUIRE_TOOLKIT)),1)
ENV += TOOLKIT_ROOT=$(WORK_DIR)/../../../toolkit/syno-$(ARCH)-$(TCVERSION)/work
TOOLKIT_ROOT=$(WORK_DIR)/../../../toolkit/syno-$(ARCH)-$(TCVERSION)/work
endif

ifneq ($(strip $(TC)),)
TC_VARS_MK = $(WORK_DIR)/tc_vars.mk

# These two variables are needed to build the CFLAGS and LDFLAGS env variables
export INSTALL_DIR
export INSTALL_PREFIX

$(TC_VARS_MK):
	$(create_target_dir)
	@$(MSG) "Set up toolchain "
	@if env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) ; \
	then \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) tc_vars > $@ ; \
	else \
	  echo "$$""(error An error occured while setting up the toolchain, please check the messages above)" > $@; \
	fi

-include $(TC_VARS_MK)
ENV += TC=$(TC)
ENV += $(TC_ENV)
endif

#ifneq ($(COMPILE_MAKE_OPTIONS),)
#ENV += MAKEFLAGS="$(COMPILE_MAKE_OPTIONS)"
#endif

PKG_CONFIG_LIBDIR = $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig

ENV += PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR)
ENV += WORK_DIR=$(WORK_DIR)
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)

ifeq ($(strip $(REQUIRE_KERNEL)),1)
ENV += REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)"
ENV += KERNEL_ROOT=$(WORK_DIR)/linux
KERNEL_ROOT=$(WORK_DIR)/linux
endif

ifeq ($(strip $(REQUIRE_TOOLKIT)),1)
ENV += TOOLKIT_ROOT=$(WORK_DIR)/../../../toolkit/syno-$(ARCH)-$(TCVERSION)/work
TOOLKIT_ROOT=$(WORK_DIR)/../../../toolkit/syno-$(ARCH)-$(TCVERSION)/work
endif

ifneq ($(strip $(TC)),)
TC_VARS_MK = $(WORK_DIR)/tc_vars.mk
TC_VARS_CMAKE = $(WORK_DIR)/tc_vars.cmake

# These two variables are needed to build the CFLAGS and LDFLAGS env variables
export INSTALL_DIR
export INSTALL_PREFIX

$(TC_VARS_MK):
	$(create_target_dir)
ifeq ($(strip $(MAKECMDGOALS)),download)
	@$(MSG) "Downloading toolchain"
	@if env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) download ; \
	then \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) tc_vars > $(TC_VARS_MK) ; \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) cmake_vars > $(TC_VARS_CMAKE) ; \
	else \
	  echo "$$""(error An error occured while downloading the toolchain, please check the messages above)" > $@; \
	fi
else
	@$(MSG) "Setting-up toolchain "
	@if env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) ; \
	then \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) tc_vars > $(TC_VARS_MK) ; \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) cmake_vars > $(TC_VARS_CMAKE) ; \
	else \
	  echo "$$""(error An error occured while setting up the toolchain, please check the messages above)" > $@; \
	fi
endif

-include $(TC_VARS_MK)
ifneq ($(strip $(CMAKE_USE_TOOLCHAIN_FILE)),ON)
ENV += TC=$(TC)
ENV += $(TC_ENV)
endif
endif

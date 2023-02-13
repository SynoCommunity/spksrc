PKG_CONFIG_LIBDIR = $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig

ENV += PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR)
ENV += WORK_DIR=$(WORK_DIR)
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)

ifeq ($(strip $(REQUIRE_KERNEL)),1)
ENV += REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)"
KERNEL_ROOT = $(WORK_DIR)/linux
ENV += KERNEL_ROOT=$(KERNEL_ROOT)
endif

ifeq ($(strip $(REQUIRE_TOOLKIT)),1)
TOOLKIT_ROOT = $(WORK_DIR)/../../../toolkit/syno-$(ARCH)-$(TCVERSION)/work
ENV += TOOLKIT_ROOT=$(TOOLKIT_ROOT)
endif

ifeq ($(strip $(GCC_DEBUG_INFO)),1)
GCC_DEBUG_FLAGS = -O0 -g3
ADDITIONAL_CFLAGS := $(patsubst -O%,,$(ADDITIONAL_CFLAGS)) $(GCC_DEBUG_FLAGS)
ADDITIONAL_CPPFLAGS := $(patsubst -O%,,$(ADDITIONAL_CPPFLAGS)) $(GCC_DEBUG_FLAGS)
ADDITIONAL_CXXFLAGS := $(patsubst -O%,,$(ADDITIONAL_CXXFLAGS)) $(GCC_DEBUG_FLAGS)
endif

ifneq ($(strip $(TC)),)
TC_VARS_MK = $(WORK_DIR)/tc_vars.mk
TC_VARS_CMAKE = $(WORK_DIR)/tc_vars.cmake
TC_VARS_MESON = $(WORK_DIR)/tc_vars.meson

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
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) meson_vars > $(TC_VARS_MESON) ; \
	else \
	  echo "$$""(error An error occured while downloading the toolchain, please check the messages above)" > $@; \
	fi
else
	@$(MSG) "Setting-up toolchain "
	@if env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) ; \
	then \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) tc_vars > $(TC_VARS_MK) ; \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) cmake_vars > $(TC_VARS_CMAKE) ; \
	  env $(MAKE) --no-print-directory -C ../../toolchain/$(TC) meson_vars > $(TC_VARS_MESON) ; \
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

# Allow toolchain mandatory variables to
# be available at all build stages in
# particular for dependencies (spksrc.depends.mk)
ENV += TC_GCC=$$(eval $$(echo $(WORK_DIR)/../../../toolchain/syno-$(ARCH)-$(TCVERSION)/work/$(TC_TARGET)/bin/$(TC_PREFIX)gcc -dumpversion) 2>/dev/null || true)
ENV += TC_GLIBC=$(TC_GLIBC)
ENV += TC_KERNEL=$(TC_KERNEL)

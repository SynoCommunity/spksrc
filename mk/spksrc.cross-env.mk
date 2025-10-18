PKG_CONFIG_LIBDIR = $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig

ENV += PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR)
ENV += WORK_DIR=$(WORK_DIR)
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)

# Ensure toolchain is always built in its directory
# Affected by kernel-modules which otherwise change
# the value of WORK_DIR to build modules locally
TC_WORK_DIR=$(abspath $(WORK_DIR)/../../../toolchain/$(TC)/work)
ENV += TC_WORK_DIR=$(TC_WORK_DIR)

ifeq ($(strip $(REQUIRE_KERNEL)),1)
ENV += REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)"
KERNEL_ROOT = $(WORK_DIR)/linux
ENV += KERNEL_ROOT=$(KERNEL_ROOT)
endif

ifeq ($(strip $(REQUIRE_TOOLKIT)),1)
TOOLKIT_ROOT = $(WORK_DIR)/../../../toolkit/syno-$(ARCH)-$(TCVERSION)/work
ENV += TOOLKIT_ROOT=$(TOOLKIT_ROOT)
endif

ifneq ($(strip $(TC)),)
TC_VARS_MK = $(WORK_DIR)/tc_vars.mk
TC_VARS_CMAKE = $(WORK_DIR)/tc_vars.cmake
TC_VARS_MESON_CROSS = $(WORK_DIR)/tc_vars.meson-cross
TC_VARS_MESON_NATIVE = $(WORK_DIR)/tc_vars.meson-native

# Mandatory to build the CFLAGS and LDFLAGS env variables
export INSTALL_DIR
export INSTALL_PREFIX

$(TC_VARS_MK):
	$(create_target_dir)
ifeq ($(strip $(MAKECMDGOALS)),download)
	@$(MSG) "Downloading toolchain"
	@if env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) download ; \
	then \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) tc_vars > $(TC_VARS_MK) ; \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) cmake_vars > $(TC_VARS_CMAKE) ; \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) meson_cross_vars > $(TC_VARS_MESON_CROSS) ; \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) meson_native_vars > $(TC_VARS_MESON_NATIVE) ; \
	else \
	  echo "$$""(error An error occured while downloading the toolchain, please check the messages above)" > $@; \
	fi
else
	@$(MSG) "Setting-up toolchain "
	@if env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) ; \
	then \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) tc_vars > $(TC_VARS_MK) ; \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) cmake_vars > $(TC_VARS_CMAKE) ; \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) meson_cross_vars > $(TC_VARS_MESON_CROSS) ; \
	  env $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) meson_native_vars > $(TC_VARS_MESON_NATIVE) ; \
	else \
	  echo "$$""(error An error occured while setting up the toolchain, please check the messages above)" > $@; \
	fi
endif

-include $(TC_VARS_MK)
ENV += TC=$(TC)
ENV += $(TC_ENV)
endif

# Allow toolchain mandatory variables to
# be available at all build stages in
# particular for dependencies (spksrc.depends.mk)
ENV += TC_GCC=$$(eval $$(echo $(WORK_DIR)/../../../toolchain/syno-$(ARCH)-$(TCVERSION)/work/$(TC_TARGET)/bin/$(TC_PREFIX)gcc -dumpversion) 2>/dev/null || true)
ENV += TC_GLIBC=$(TC_GLIBC)
ENV += TC_KERNEL=$(TC_KERNEL)

# Debug flags (remove any other -O%):
#  -ggdb3 generates extensive debug info optimized for GDB
#  -g3 includes macro definitions in debug info
#  -O0 disables optimizations for predictable debugging
#  -gz compresses debug sections to reduce file size (60-80% smaller)
ifeq ($(strip $(GCC_DEBUG_INFO)),1)
  ifeq ($(strip $(GCC_DEBUG_FLAGS)),)
    GCC_DEBUG_FLAGS = -ggdb3 -g3 -O0

    # Check compression support and add to flags
    GCC_SUPPORTS_GZ := $(shell echo | $(WORK_DIR)/../../../toolchain/syno-$(ARCH)-$(TCVERSION)/work/$(TC_TARGET)/bin/$(TC_PREFIX)gcc -gz -E - 2>/dev/null 1>&2 && echo yes)
    ifeq ($(strip $(GCC_SUPPORTS_GZ)),yes)
      GCC_DEBUG_FLAGS += -gz
    endif
  endif

  ADDITIONAL_CFLAGS := $(patsubst -O%,,$(ADDITIONAL_CFLAGS))
  ADDITIONAL_CPPFLAGS := $(patsubst -O%,,$(ADDITIONAL_CPPFLAGS))
  ADDITIONAL_CXXFLAGS := $(patsubst -O%,,$(ADDITIONAL_CXXFLAGS))

# gcc:
#  -g0 deactivates debug information generation
#  -Os enable some optimizations while avoiding those that increases space
#  -flto enable optimization at link time (Link Time Optimization)
#  -ffunction-sections -fdata-sections allows placing functions in their own ELF section
# ld:
#  -Wl,--gc-sections allows removing unused functions set previously (-f*-sections)
#  -w omits the DWARF symbol table removing debugging information
#  -s strips the symbol table and debug information from the binary
else ifeq ($(strip $(GCC_NO_DEBUG_INFO)),1)
  GCC_NO_DEBUG_FLAGS = -g0 -Os -ffunction-sections -fdata-sections -fvisibility=hidden
  ADDITIONAL_CFLAGS := $(patsubst -O%,,$(ADDITIONAL_CFLAGS)) $(GCC_NO_DEBUG_FLAGS)
  ADDITIONAL_CPPFLAGS := $(patsubst -O%,,$(ADDITIONAL_CPPFLAGS)) $(GCC_NO_DEBUG_FLAGS)
  ADDITIONAL_CXXFLAGS := $(patsubst -O%,,$(ADDITIONAL_CXXFLAGS)) $(GCC_NO_DEBUG_FLAGS)
  ADDITIONAL_LDFLAGS := $(ADDITIONAL_LDFLAGS) -w -s -Wl,--gc-sections
endif

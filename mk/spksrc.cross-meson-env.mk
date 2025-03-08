# meson cross-compilation definitions

# Set default base meson directory
# Exceptionnally it is under a sub-directory (ex: zstd)
ifeq ($(strip $(MESON_BASE_DIR)),)
MESON_BASE_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

# Set default build directory
ifeq ($(strip $(MESON_BUILD_DIR)),)
MESON_BUILD_DIR = $(MESON_BASE_DIR)/builddir
endif

# Set other build options
# We normally build regular Release
ifeq ($(strip $(MESON_BUILD_TYPE)),)
CONFIGURE_ARGS += -Dbuildtype=release
else
CONFIGURE_ARGS += -Dbuildtype=$(MESON_BUILD_TYPE)
endif

# Configuration for meson build
MESON_TOOLCHAIN_NAME = $(ARCH)-toolchain.meson
MESON_CROSS_TOOLCHAIN_WRK = $(WORK_DIR)/tc_vars.meson-cross
MESON_CROSS_TOOLCHAIN_PKG = $(WORK_DIR)/$(PKG_DIR)/$(MESON_TOOLCHAIN_NAME)
MESON_NATIVE_TOOLCHAIN_WRK = $(WORK_DIR)/tc_vars.meson-native
CONFIGURE_ARGS += --cross-file=$(MESON_CROSS_TOOLCHAIN_PKG)
#CONFIGURE_ARGS += --native-file=$(MESON_NATIVE_TOOLCHAIN_WRK)

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
  MESON_HOST_CPU_FAMILY = arm
  MESON_HOST_CPU = armv5
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
  MESON_BUILTIN_CPP_ARGS = -fPIC
  MESON_BUILTIN_FC_ARGS = -fPIC
  MESON_HOST_CPU_FAMILY = arm
  MESON_HOST_CPU = armv7
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
  MESON_BUILTIN_CPP_ARGS = -fPIC
  MESON_BUILTIN_FC_ARGS = -fPIC
  MESON_HOST_CPU_FAMILY = arm
  MESON_HOST_CPU = armv7l
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
  MESON_BUILTIN_CPP_ARGS = -fPIC
  MESON_BUILTIN_FC_ARGS = -fPIC
  MESON_HOST_CPU_FAMILY = aarch64
  MESON_HOST_CPU = aarch64
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
  MESON_HOST_CPU_FAMILY = ppc
  MESON_HOST_CPU = ppc
  MESON_HOST_ENDIAN = big
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  MESON_BUILTIN_C_ARGS = -m32
  MESON_BUILTIN_C_LINK_ARGS = -m32
  MESON_BUILTIN_CPP_ARGS = -m32
  MESON_BUILTIN_CPP_LINK_ARGS = -m32
  MESON_BUILTIN_FC_ARGS = -m32
  MESON_BUILTIN_FC_LINK_ARGS = -m32
  MESON_HOST_CPU_FAMILY = x86
  MESON_HOST_CPU = i686
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  MESON_HOST_CPU_FAMILY = x86_64
  MESON_HOST_CPU = x86_64
  MESON_HOST_ENDIAN = little
endif

.PHONY: $(MESON_CROSS_TOOLCHAIN_PKG)
$(MESON_CROSS_TOOLCHAIN_PKG):
	@$(MSG) Generating $(MESON_TOOLCHAIN_PKG)
	env $(MAKE) --no-print-directory meson_pkg_toolchain > $(MESON_CROSS_TOOLCHAIN_PKG) 2>/dev/null;

.PHONY: meson_pkg_toolchain
meson_pkg_toolchain: SHELL:=/bin/bash
meson_pkg_toolchain:
	@cat $(MESON_CROSS_TOOLCHAIN_WRK)
ifeq ($(strip $(MESON_PYTHON)),1)
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@. $(CROSSENV) ; \
	export PATH=$(call dedup,$(CROSSENV_PATH)/cross/bin:$(CROSSENV_PATH)/build/bin:$(CROSSENV_PATH)/bin:$${PATH}, :) ; \
	echo "cython = '$$(which cython)'" ; \
	echo "meson = '$$(which meson)'" ; \
	echo "pkg-config = '$$(which pkg-config)'" ; \
	echo "python = '$$(which cross-python)'"
endif
	@echo
	@echo "[built-in options]" ; \
	echo "prefix = '$(STAGING_INSTALL_PREFIX)'"
	@echo
	@echo "[properties]" ; \
	echo "pkg_config_path = '$(abspath $(PKG_CONFIG_LIBDIR))'"
	@echo
	@echo "[built-in]" ; \
	echo "c_args = ["
ifneq ($(strip $(MESON_BUILTIN_C_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_C_ARGS)',\n"
endif
	@echo $(CFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "c_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_C_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_C_LINK_ARGS)',\n"
endif
	@echo $(LDFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "cpp_args = ["
ifneq ($(strip $(MESON_BUILTIN_CPP_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_CPP_ARGS)',\n"
endif
	@echo $(CPPFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "cpp_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_CPP_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_CPP_LINK_ARGS)',\n"
endif
	@echo $(LDFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "cxx_args = ["
	@echo $(CXXFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "fc_args = ["
ifneq ($(strip $(MESON_BUILTIN_FC_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_FC_ARGS)',\n"
endif
	@echo $(FFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "fc_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_FC_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_FC_LINK_ARGS)',\n"
endif
	@echo $(LDFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"

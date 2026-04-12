# meson cross-file definitions

# Per-dependency configuration for meson build
MESON_CROSS_FILE_NAME = $(ARCH)-crossfile.meson
MESON_CROSS_FILE_PKG = $(WORK_DIR)/$(PKG_DIR)/$(MESON_CROSS_FILE_NAME)
CONFIGURE_ARGS += --cross-file=$(MESON_CROSS_FILE_PKG)

# Map DEFAULT_ENV definitions to filenames
TC_VARS_FILES := $(wildcard $(foreach b,$(DEFAULT_ENV),$(WORK_DIR)/tc_vars.$(b).mk))
# Include them (optional include)
-include $(TC_VARS_FILES)

# Meson specific targets
.PHONY: meson_generate_crossfile
meson_generate_crossfile:
	$(MAKE) --no-print-directory DEFAULT_ENV="flags rust" $(MESON_CROSS_FILE_PKG)

.PHONY: $(MESON_CROSS_FILE_PKG)
$(MESON_CROSS_FILE_PKG):
	@$(MSG) Generating $(MESON_CROSS_FILE_PKG)
	@env $(ENV) $(MAKE) --no-print-directory generate_meson_crossfile_pkg > $(MESON_CROSS_FILE_PKG) 2>/dev/null;

.PHONY: generate_meson_crossfile_pkg
generate_meson_crossfile_pkg: SHELL:=/bin/bash
generate_meson_crossfile_pkg:
	@cat $(MESON_CROSS_FILE_WRK)
	@echo "pkgconfig = '$$(which pkg-config)'"
	@echo "pkg-config = '$$(which pkg-config)'"
ifeq ($(strip $(MESON_PYTHON)),1)
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@. $(CROSSENV) ; \
	export PATH=$(call dedup,$(CROSSENV_PATH)/cross/bin:$(CROSSENV_PATH)/build/bin:$(CROSSENV_PATH)/bin:$${PATH}, :) ; \
	echo "cython = '$$(which cython)'" ; \
	echo "meson = '$$(which meson)'" ; \
	echo "python = '$$(which cross-python)'"
endif
	@echo
	@echo "[properties]" ; \
	echo "# Not needed due to PKG_CONFIG_LIBDIR" ; \
	echo "#pkg_config_path = '$(abspath $(PKG_CONFIG_LIBDIR))'"
	@echo
	@echo "[built-in options]" ; \
	echo "prefix = '$(INSTALL_PREFIX)'"
ifeq ($(GCC_DEBUG_INFO),1)
	@echo "debug = 'true'" ; \
	echo "b_ndebug = 'true'" ; \
	echo "optimization = '$(strip $(patsubst -O%,%,$(filter -O%,$(GCC_DEBUG_FLAGS))))'" ; \
	echo
endif
	@echo "c_args = ["
ifneq ($(strip $(MESON_BUILTIN_C_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_C_ARGS)',\n"
endif
ifeq ($(GCC_DEBUG_INFO),1)
	@echo $(call uniq,$(patsubst -O%,,$(CFLAGS) $(GCC_DEBUG_FLAGS) $(TC_EXTRA_CFLAGS) $(ADDITIONAL_CFLAGS))) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
else
	@echo $(call uniq,$(CFLAGS) $(TC_EXTRA_CFLAGS) $(ADDITIONAL_CFLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
endif
	@echo -ne "\t]\n"
	@echo
	@echo "c_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_C_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_C_LINK_ARGS)',\n"
endif
	@echo $(call uniq,$(LDFLAGS) $(ADDITIONAL_LDFLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "cpp_args = ["
ifneq ($(strip $(MESON_BUILTIN_CPP_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_CPP_ARGS)',\n"
endif
ifeq ($(GCC_DEBUG_INFO),1)
	@echo $(call uniq,$(patsubst -O%,,$(CPPFLAGS) $(GCC_DEBUG_FLAGS) $(ADDITIONAL_CPPFLAGS))) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
else
	@echo $(call uniq,$(CPPFLAGS) $(ADDITIONAL_CPPFLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
endif
	@echo -ne "\t]\n"
	@echo
	@echo "cpp_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_CPP_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_CPP_LINK_ARGS)',\n"
endif
	@echo $(call uniq,$(LDFLAGS) $(ADDITIONAL_LDFLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
ifneq ($(strip $(FFLAGS)),)
	@echo "fortran_args = ["
ifneq ($(strip $(MESON_BUILTIN_FC_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_FC_ARGS)',\n"
endif
ifeq ($(GCC_DEBUG_INFO),1)
	@echo $(call uniq,$(patsubst -O%,,$(FFLAGS) $(GCC_DEBUG_FLAGS) $(ADDITIONAL_FFLAGS))) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
else
	@echo $(call uniq,$(FFLAGS) $(ADDITIONAL_FFLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
endif
	@echo -ne "\t]\n"
	@echo
	@echo "fortran_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_FC_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_FC_LINK_ARGS)',\n"
endif
	@echo $(call uniq,$(LDFLAGS) $(ADDITIONAL_LDFLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
endif
	@echo "rust_args = [" ; \
	echo -ne "\t'--target=$(RUST_TARGET)',\n" ; \
	echo -ne "\t'-Clinker=$(TC_PATH)$(TC_PREFIX)gcc',\n"
ifneq ($(strip $(MESON_BUILTIN_RUST_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_RUST_ARGS)',\n"
endif
	@echo $(call uniq,$(RUSTFLAGS) $(TC_EXTRA_RUSTFLAGS) $(ADDITIONAL_RUSTFLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
	@echo -ne "\t]\n"

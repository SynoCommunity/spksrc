# meson cross-file definitions

# Per-dependency configuration for meson build
MESON_CROSS_FILE_NAME = $(ARCH)-crossfile.meson
MESON_CROSS_FILE_PKG = $(WORK_DIR)/$(PKG_DIR)/$(MESON_CROSS_FILE_NAME)
CONFIGURE_ARGS += --cross-file=$(MESON_CROSS_FILE_PKG)

# Enforce running in a clean environement to avoid
# issues between 'build' and 'host' environments
ENV_MESON = $(addprefix -u ,$(VARS_TO_CLEAN)) $(ENV_FILTERED)
RUN_MESON = cd $(MESON_BASE_DIR) && env $(ENV_MESON)

.PHONY: $(MESON_CROSS_FILE_PKG)
$(MESON_CROSS_FILE_PKG):
	@$(MSG) Generating $(MESON_CROSS_FILE_PKG)
	env $(MAKE) --no-print-directory generate_meson_crossfile_pkg > $(MESON_CROSS_FILE_PKG) 2>/dev/null;

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
	@echo $(patsubst -O%,,$(CFLAGS) $(GCC_DEBUG_FLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
else
	@echo $(CFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
endif
	@echo -ne "\t]\n"
	@echo
	@echo "c_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_C_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_C_LINK_ARGS)',\n"
endif
	@echo $(LDFLAGS) $(ADDITIONAL_LDFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "cpp_args = ["
ifneq ($(strip $(MESON_BUILTIN_CPP_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_CPP_ARGS)',\n"
endif
ifeq ($(GCC_DEBUG_INFO),1)
	@echo $(patsubst -O%,,$(CPPFLAGS) $(GCC_DEBUG_FLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
else
	@echo $(CPPFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
endif
	@echo -ne "\t]\n"
	@echo
	@echo "cpp_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_CPP_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_CPP_LINK_ARGS)',\n"
endif
	@echo $(LDFLAGS) $(ADDITIONAL_LDFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "fortran_args = ["
ifneq ($(strip $(MESON_BUILTIN_FC_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_FC_ARGS)',\n"
endif
ifeq ($(GCC_DEBUG_INFO),1)
	@echo $(patsubst -O%,,$(FFLAGS) $(GCC_DEBUG_FLAGS)) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
else
	@echo $(FFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
endif
	@echo -ne "\t]\n"
	@echo
	@echo "fortran_link_args = ["
ifneq ($(strip $(MESON_BUILTIN_FC_LINK_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_FC_LINK_ARGS)',\n"
endif
	@echo $(LDFLAGS) $(ADDITIONAL_LDFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"
	@echo
	@echo "rust_args = [" ; \
	echo -ne "\t'--target=$(RUST_TARGET)',\n" ; \
	echo -ne "\t'-Clinker=$(TC_PATH)$(TC_PREFIX)gcc',\n"
ifneq ($(strip $(MESON_BUILTIN_RUST_ARGS)),)
	@echo -ne "\t'$(MESON_BUILTIN_RUST_ARGS)',\n"
endif
	@echo $(RUSTFLAGS) $(ADDITIONAL_RUSTFLAGS) $(TC_EXTRA_RUSTFLAGS) | tr ' ' '\n' | sed -e "s/^/\t'/" -e "s/$$/',/"
	@echo -ne "\t]\n"

# meson cross-file definitions

# Per-dependency configuration for meson build
MESON_CROSS_FILE_NAME = $(ARCH)-crossfile.meson
MESON_CROSS_FILE_PKG = $(WORK_DIR)/$(PKG_DIR)/$(MESON_CROSS_FILE_NAME)
CONFIGURE_ARGS += --cross-file=$(MESON_CROSS_FILE_PKG)

# Enforce unsetting all flags as using cross-file with the
# exception of PKG_CONFIG_LIBDIR to force default pkgconfig.
#
# Also due to meson bug, keep LDFLAGS for rpath management.
# This only occurs when there are multiple rpath definitions.
# Ref: https://github.com/mesonbuild/meson/issues/14354
#      https://github.com/mesonbuild/meson/issues/6541
#
# Note0: The only way to get rpath defined in resulting *.so
#        is from using LDFLAGS variable part of environment.
# Note1: Adding options --enable-new-dtags or --strip-all to
#        *_link_args has no effect on resulting rpath and runpath.
# Note2: Defining build_rpath and install_rpath has no effect.
#        It should normally affect the runpath and not the rpath.
# Note3: Similarly, re-defining -Wl,--rpath-link and -Wl,--rpath
#        part of *_link_args has no effect neither as LDFLAGS
#        needs to be set anyway and already has rpath defined.
# Note4: Defining runpath (instead of rpath) using install_rpath
#        or -Wl,--enable-new-dtags has no effect neither.
#
ENV_MESON  = -u AR -u AS -u CC -u CPP -u CXX -u LD -u LDSHARED
ENV_MESON += -u OBJCOPY -u OBJDUMP -u RANLIB -u READELF -u STRIP
ENV_MESON += -u CFLAGS -u ADDITIONAL_CFLAGS
ENV_MESON += -u CPPFLAGS -u ADDITIONAL_CPPFLAGS
ENV_MESON += -u CXXFLAGS -u ADDITIONAL_CXXFLAGS
ENV_MESON += -u FFLAGS -u ADDITIONAL_FFLAGS
#ENV_MESON += -u LDFLAGS -u ADDITIONAL_LDFLAGS
ENV_MESON += -u PKG_CONFIG_PATH -u SYSROOT
ENV_MESON += $(ENV)

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
	@echo "[built-in options]" ; \
	echo "prefix = '$(INSTALL_PREFIX)'"
	@echo
	@echo "[properties]" ; \
	echo "# Not needed due to PKG_CONFIG_LIBDIR" ; \
	echo "#pkg_config_path = '$(abspath $(PKG_CONFIG_LIBDIR))'"
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
	@echo $(LDFLAGS) | tr ' ' '\n' | grep -v rpath | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
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
	@echo $(LDFLAGS) | tr ' ' '\n' | grep -v rpath | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
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
	@echo $(LDFLAGS) | tr ' ' '\n' | grep -v rpath | sed -e "s/^/\t'/" -e "s/$$/',/" ; \
	echo -ne "\t]\n"

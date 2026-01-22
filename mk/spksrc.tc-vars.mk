### tc_vars rules

# Configure the included makefiles
URLS                       = $(TC_DIST_SITE)/$(TC_DIST_NAME)
NAME                       = $(TC_NAME)
COOKIE_PREFIX              =
ifneq ($(strip $(TC_DIST_FILE)),)
LOCAL_FILE                 = $(TC_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE              = $(TC_DIST_FILE)
else
LOCAL_FILE                 = $(TC_DIST_NAME)
endif
DISTRIB_DIR                = $(TOOLCHAIN_DIR)/$(TC_VERS)
DIST_FILE                  = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT                   = $(TC_EXT)

ifneq ($(strip $(ARCH)),)
ARCH_SUFFIX := -$(ARCH)-$(TCVERSION)
else
ARCH_SUFFIX :=
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.directories.mk

### Include common definitions
include ../../mk/spksrc.common.mk

#####

# Include cross-compilation definitions
# (provides arch-specific variables for toolchain generation)
include ../../mk/spksrc.cross-cmake-env.mk
include ../../mk/spksrc.cross-meson-env.mk
include ../../mk/spksrc.cross-rust-env.mk

#####

# Avoid looping when calling itself
ifeq ($(TCVARS_SUBMAKE),1)
.DEFAULT_GOAL :=
else
.DEFAULT_GOAL := tcvars
endif

RUN = cd $(WORK_DIR)/$(TC_TARGET) && env $(ENV)

#####

# Mappings (target_name:output_file)
TC_VAR_MAPPING_MK = \
	tc_vars:tc_vars.mk \
	tc_flags:tc_vars.flags.mk \
	tc_autotools_vars:tc_vars.autotools.mk \
	tc_rust_vars:tc_vars.rust.mk

TC_VAR_MAPPING_OTHER = \
	tc_cmake_vars:tc_vars.cmake \
	tc_meson_cross_vars:tc_vars.meson-cross \
	tc_meson_native_vars:tc_vars.meson-native

# Common variables to simply calls
# (e.g. direct call such as 'make work/tc_vars.mk')
TC_VARS_MK           = $(WORK_DIR)/tc_vars.mk
TC_VARS_AUTOTOOLS_MK = $(WORK_DIR)/tc_vars.autotools.mk
TC_VARS_FLAGS_MK     = $(WORK_DIR)/tc_vars.flags.mk
TC_VARS_RUST_MK      = $(WORK_DIR)/tc_vars.rust.mk
TC_VARS_CMAKE        = $(WORK_DIR)/tc_vars.cmake
TC_VARS_MESON_CROSS  = $(WORK_DIR)/tc_vars.meson-cross
TC_VARS_MESON_NATIVE = $(WORK_DIR)/tc_vars.meson-native

# Template to generate toolchain rule
define make_tc_var_rule
$(WORK_DIR)/$(2):
	@$(MSG) "Generating $(WORK_DIR)/$(2)"
	@$(MAKE) --no-print-directory \
		-f Makefile \
		TCVARS_SUBMAKE=1 \
		$(1) > $$@
endef

# Generate all .mk files
$(foreach mapping,$(TC_VAR_MAPPING_MK),\
  $(eval $(call make_tc_var_rule,$(word 1,$(subst :, ,$(mapping))),$(word 2,$(subst :, ,$(mapping))))))

# Generate all other targets (cmake, meson)
$(foreach mapping,$(TC_VAR_MAPPING_OTHER),\
  $(eval $(call make_tc_var_rule,$(word 1,$(subst :, ,$(mapping))),$(word 2,$(subst :, ,$(mapping))))))

# Grouped targets to generate multiple files
.PHONY: generate_tc_vars_mk
generate_tc_vars_mk: $(foreach m,$(TC_VAR_MAPPING_MK),$(WORK_DIR)/$(word 2,$(subst :, ,$(m))))

.PHONY: generate_tc_vars_other
generate_tc_vars_other: $(foreach m,$(TC_VAR_MAPPING_OTHER),$(WORK_DIR)/$(word 2,$(subst :, ,$(m))))

#####

TCVARS_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)tcvars_done

.PHONY: $(PRE_TCVARS_TARGET) $(TCVARS_TARGET) $(POST_TCVARS_TARGET)
ifeq ($(strip $(PRE_TCVARS_TARGET)),)
PRE_TCVARS_TARGET = pre_tcvars_target
else
$(PRE_TCVARS_TARGET): tcvars_msg
endif
ifeq ($(strip $(TCVARS_TARGET)),)
TCVARS_TARGET = tcvars_target
else
$(TCVARS_TARGET): $(PRE_TCVARS_TARGET)
endif
ifeq ($(strip $(POST_TCVARS_TARGET)),)
POST_TCVARS_TARGET = post_tcvars_target
else
$(POST_TCVARS_TARGET): $(TCVARS_TARGET)
endif

.PHONY: tcvars_msg
tcvars_msg:
	@$(MSG) "Preparing toolchain cross-compilation configuration files for $(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS)"

#####

pre_tcvars_target: tcvars_msg

.PHONY: tcvars_target
tcvars_target: \
	$(TC_VARS_MK) \
	$(TC_VARS_AUTOTOOLS_MK) \
	$(TC_VARS_FLAGS_MK) \
	$(TC_VARS_RUST_MK) \
	$(TC_VARS_CMAKE) \
	$(TC_VARS_MESON_CROSS) \
	$(TC_VARS_MESON_NATIVE)

post_tcvars_target: $(TCVARS_TARGET)

#####

.PHONY: tc_cmake_vars
tc_cmake_vars:
	@echo "# the name of the target operating system" ; \
	echo "set(CMAKE_SYSTEM_NAME $(CMAKE_SYSTEM_NAME))" ; \
	echo
	@echo "# define target processor" ; \
	echo "set(CMAKE_SYSTEM_PROCESSOR $(CMAKE_SYSTEM_PROCESSOR))"
ifneq ($(strip $(CROSS_COMPILE_ARM)),)
	@echo "set(CROSS_COMPILE_ARM $(CROSS_COMPILE_ARM))"
endif
ifneq ($(strip $(CMAKE_ARCH)),)
	@echo "set(ARCH $(CMAKE_ARCH))"
endif
	@echo
	@echo "# Disable developer warnings" ; \
	echo 'set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS ON CACHE BOOL "Disable developer warnings")'
	@echo
	@echo "# define toolchain location (used with CMAKE_TCVARS_FILE_PKG)" ; \
	echo "set(_CMAKE_TOOLCHAIN_LOCATION $(_CMAKE_TOOLCHAIN_LOCATION))" ; \
	echo "set(_CMAKE_TOOLCHAIN_PREFIX $(_CMAKE_TOOLCHAIN_PREFIX))" ; \
	echo
	@echo "# define cross-compilers and tools to use" ; \
	for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/' | tr [:lower:] [:upper:] ) ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/' ) ; \
	  if [ "$${target}" = "CC" ] ; then \
	    printf "set(%-25s %s)\n" CMAKE_C_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source} ; \
	  elif [ "$${target}" = "CPP" -o "$${target}" = "CXX" ] ; then \
	    printf "set(%-25s %s)\n" CMAKE_$${target}_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source} ; \
	  elif [ "$${target}" = "LD" ] ; then \
	    printf "set(%-25s %s)\n" CMAKE_LINKER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source} ; \
	  elif [ "$${target}" = "LDSHARED" ] ; then \
	    printf "set(%-25s %s)\n" CMAKE_SHARED_LINKER_FLAGS $$(echo $${source} | cut -f2 -d' ') ; \
	  elif [ "$${target}" = "FC" ] ; then \
	    printf "set(%-25s %s)\n" CMAKE_Fortran_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$$(echo $${source} | cut -f2 -d' ') ; \
	  else \
	    printf "set(%-25s %s)\n" CMAKE_$${target} $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source} ; \
	  fi ; \
	done ; \
	echo
	@echo "# define 'build' compilers and tools to use" ; \
	for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/' | tr [:lower:] [:upper:] ) ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/' ) ; \
	  if [ "$${target}" = "CC" ] ; then \
	    printf "set(%-35s %s)\n" CMAKE_C_COMPILER_FOR_BUILD $$(which $${source}) ; \
	  elif [ "$${target}" = "CPP" -o "$${target}" = "CXX" ] ; then \
	    printf "set(%-35s %s)\n" CMAKE_$${target}_COMPILER_FOR_BUILD $$(which $${source}) ; \
	  elif [ "$${target}" = "LD" ] ; then \
	    printf "set(%-35s %s)\n" CMAKE_LINKER_FOR_BUILD $$(which $${source}) ; \
	  elif [ "$${target}" = "LDSHARED" ] ; then \
	    printf "set(%-25s %s)\n" CMAKE_SHARED_LINKER_FLAGS_FOR_BUILD $$(echo $${source} | cut -f2 -d' ') ; \
	  elif [ "$${target}" = "FC" ] ; then \
	    printf "set(%-35s %s)\n" CMAKE_Fortran_COMPILER_FOR_BUILD $$(which $${source}) ; \
	  else \
	    printf "set(%-35s %s)\n" CMAKE_$${target}_FOR_BUILD $$(which $${source}) ; \
	  fi ; \
	done ; \
	echo
	@echo "# where is the target environment located" ; \
	echo "set(CMAKE_FIND_ROOT_PATH $(CMAKE_FIND_ROOT_PATH))" ; \
	echo ; \
	echo "# adjust the default behavior of the FIND_XXX() commands:" ; \
	echo "# search programs in the host environment" ; \
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM $(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM))" ; \
	echo ; \
	echo "# search headers and libraries in the target environment" ; \
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY $(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY))" ; \
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE $(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE))"
	@echo ; \
	echo "# Default visibility for Docker compatibility" ; \
	echo "if(NOT DEFINED CMAKE_CXX_VISIBILITY_PRESET)" ; \
	echo "    set(CMAKE_CXX_VISIBILITY_PRESET default CACHE STRING \"Symbol visibility preset\")" ; \
	echo "endif()" ;\
	echo "if(NOT DEFINED CMAKE_C_VISIBILITY_PRESET)" ; \
	echo "    set(CMAKE_C_VISIBILITY_PRESET default CACHE STRING \"Symbol visibility preset\")" ; \
	echo "endif()"
	@echo ; \
	echo "# Rust compiler and Cargo" ; \
	echo "set(CARGO  $(RUSTUP_HOME)/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo)"
ifeq ($(TC_RUSTUP_TOOLCHAIN),stable)
	@echo "set(RUSTC  $(RUSTUP_HOME)/toolchains/$(TC_RUSTUP_TOOLCHAIN)-x86_64-unknown-linux-gnu/bin/rustc)"
else
	@echo "set(RUSTC  $(RUSTUP_HOME)/toolchains/$(TC_RUSTUP_TOOLCHAIN)/bin/rustc)"
endif
	@echo ; \
	echo "# Cross target triple" ; \
	echo "set(RUST_TARGET  $(RUST_TARGET))" ; \
	echo ; \
	echo "# Rust linker and AR" ; \
	echo "set(RUST_LINKER  \$${CMAKE_C_COMPILER})" ; \
	echo "set(RUST_AR      \$${CMAKE_AR})" ; \
	echo ; \
	echo "# Export Rust environment for Cargo builds" ; \
	echo "set(ENV{RUSTC} \$${RUSTC})" ; \
	echo "set(ENV{CARGO} \$${CARGO})" ; \
	echo "set(ENV{CARGO_BUILD_TARGET} \$${RUST_TARGET})" ; \
	echo "set(ENV{CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_LINKER} \$${RUST_LINKER})" ; \
	echo "set(ENV{CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_AR} \$${RUST_AR})" ; \
	echo "set(ENV{CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_RUSTFLAGS} $(TC_EXTRA_RUSTFLAGS))"

.PHONY: tc_meson_cross_vars
tc_meson_cross_vars:
	@echo "[host_machine]" ; \
	echo "system = 'linux'" ; \
	echo "cpu_family = '$(MESON_HOST_CPU_FAMILY)'" ; \
	echo "cpu = '$(MESON_HOST_CPU)'" ; \
	echo "endian = '$(MESON_HOST_ENDIAN)'"
	@echo
	@echo "[binaries]" ; \
	for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/' ) ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/' ) ; \
	  if [ "$${target}" = "cpp" ]; then \
	    echo "# Ref: https://mesonbuild.com/Machine-files.html#binaries" ; \
	    echo "$${target} = '$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)g++'" ; \
	  elif [ "$${target}" = "fc" ]; then \
	    echo "fortran = '$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source}'" ; \
	  elif [ "$${target}" = "cc" ]; then \
	    echo "c = '$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source}'" ; \
	    echo "$${target} = '$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source}'" ; \
	  else \
	    echo "$${target} = '$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source}'" ; \
	  fi ; \
	done
	@echo "cargo = '$(RUSTUP_HOME)/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo'"
ifeq ($(TC_RUSTUP_TOOLCHAIN),stable)
	@echo "rust = '$(RUSTUP_HOME)/toolchains/$(TC_RUSTUP_TOOLCHAIN)-x86_64-unknown-linux-gnu/bin/rustc'"
else
	@echo "rust = '$(RUSTUP_HOME)/toolchains/$(TC_RUSTUP_TOOLCHAIN)/bin/rustc'"
endif

.PHONY: tc_meson_native_vars
tc_meson_native_vars:
	@echo "[binaries]"
	@for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/' ) ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/' ) ; \
	  if [ "$${target}" = "cc" ]; then \
	    echo "c = '$$(which $${source})'" ; \
	    echo "$${target} = '$$(which $${source})'" ; \
	  elif [ "$${target}" = "fc" ]; then \
	    echo "fortran = '$$(which $${source})'" ; \
	  elif [ "$${target}" = "ldshared" ]; then \
	    echo "$${target} = '$$(which gcc) -shared'" ; \
	  else \
	    echo "$${target} = '$$(which $${source})'" ; \
	  fi ; \
	done
	@echo "g-ir-compiler = '$$(which g-ir-compiler)'" ; \
        echo "g-ir-generate = '$$(which g-ir-generate)'" ; \
        echo "g-ir-scanner = '$$(which g-ir-scanner)'"

.PHONY: tc_rust_vars
tc_rust_vars:
	@echo TC_ENV += RUSTFLAGS=\"$(RUSTFLAGS) $$\(ADDITIONAL_RUSTFLAGS\)\" ; \
	echo TC_ENV += CARGO_HOME=\"$(realpath $(CARGO_HOME))\" ; \
	echo TC_ENV += RUSTUP_HOME=\"$(realpath $(RUSTUP_HOME))\" ; \
	echo TC_ENV += RUSTUP_TOOLCHAIN=\"$(TC_RUSTUP_TOOLCHAIN)\" ; \
	echo TC_ENV += CARGO_BUILD_TARGET=\"$(RUST_TARGET)\" ; \
	echo TC_ENV += CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_AR=\"$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)ar\" ; \
	echo TC_ENV += CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_LINKER=\"$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc\" ; \
	echo TC_ENV += CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_RUSTFLAGS=\"$(TC_EXTRA_RUSTFLAGS)\" ; \
	echo RUSTFLAGS := $(RUSTFLAGS) $$\(ADDITIONAL_RUSTFLAGS\) ; \
	echo RUST_TARGET := $(RUST_TARGET)

.PHONY: tc_autotools_vars
tc_autotools_vars:
	@echo TC_CONFIGURE_ARGS := --host=$(TC_TARGET) --build=i686-pc-linux ; \
	echo TC_ENV += SYSROOT=\"$(WORK_DIR)/$(TC_TARGET)/$(TC_SYSROOT)\" ; \
	for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/' | tr [:lower:] [:upper:] ) ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/' ) ; \
	  echo TC_ENV += $${target}=\"$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source}\" ; \
	  if [ "$${target}" = "CC" ] ; then \
	    gcc_version=$$(eval $$(echo $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source} -dumpversion) 2>/dev/null || true) ; \
	  fi ; \
	done ; \
	echo TC_ENV += CFLAGS=\"$(CFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CFLAGS\)\" ; \
	echo TC_ENV += CPPFLAGS=\"$(CPPFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CPPFLAGS\)\" ; \
	echo TC_ENV += CXXFLAGS=\"$(CXXFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CXXFLAGS\)\" ; \
	if [ -n "$(TC_HAS_FORTRAN)" ]; then \
	   echo TC_ENV += FFLAGS=\"$(FFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_FFLAGS\)\" ; \
	fi ; \
	echo TC_ENV += LDFLAGS=\"$(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)\"

.PHONY: tc_flags
tc_flags:
	@echo CFLAGS := $(CFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CFLAGS\) ; \
	echo CPPFLAGS := $(CPPFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CPPFLAGS\) ; \
	echo CXXFLAGS := $(CXXFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CXXFLAGS\) ; \
	if [ -n "$(TC_HAS_FORTRAN)" ]; then \
	   echo FFLAGS := $(FFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_FFLAGS\) ; \
	fi ; \
	echo LDFLAGS := $(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)

.PHONY: tc_vars
tc_vars:
	@echo TC_TYPE := $(TC_TYPE) ; \
	echo TC_SYSROOT := $(WORK_DIR)/$(TC_TARGET)/$(TC_SYSROOT) ; \
	echo TC_TARGET := $(TC_TARGET) ; \
	echo TC_PREFIX := $(TC_PREFIX) ; \
	echo TC_PATH := $(WORK_DIR)/$(TC_TARGET)/bin/ ; \
	echo TC_INCLUDE := $(TC_INCLUDE) ; \
	echo TC_LIBRARY := $(TC_LIBRARY) ; \
	echo TC_EXTRA_CFLAGS := $(TC_EXTRA_CFLAGS) ; \
	echo TC_EXTRA_RUSTFLAGS := $(TC_EXTRA_RUSTFLAGS) ; \
	echo TC_VERS := $(TC_VERS) ; \
	echo TC_BUILD := $(TC_BUILD) ; \
	echo TC_OS_MIN_VER := $(TC_OS_MIN_VER) ; \
	echo TC_ARCH := $(TC_ARCH) ; \
	for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/' | tr [:lower:] [:upper:] ) ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/' ) ; \
	  if [ "$${target}" = "CC" ] ; then \
	    gcc_version=$$(eval $$(echo $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source} -dumpversion) 2>/dev/null || true) ; \
	  fi ; \
	done ; \
	echo TC_GCC := $${gcc_version} ; \
	echo TC_GLIBC := $(TC_GLIBC)
# Add "+" to EXTRAVERSION for kernels version >= 4.4
ifeq ($(call version_ge, ${TC_KERNEL}, 4.4),1)
	@echo TC_KERNEL := $(TC_KERNEL)+
else
	@echo TC_KERNEL := $(TC_KERNEL)
endif

#####

ifeq ($(wildcard $(TCVARS_COOKIE)),)
tcvars: generate_tc_vars_mk generate_tc_vars_other $(TCVARS_COOKIE)

$(TCVARS_COOKIE): $(POST_TCVARS_TARGET)
	$(create_target_dir)
	@touch -f $@

else
tcvars: ;
endif

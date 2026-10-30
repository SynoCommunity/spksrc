###############################################################################
# spksrc.toolchain/tc_vars.mk
#
# This makefile generates all toolchain-specific environment definition files
# $(WORK_DIR)/tc_vars* used by spksrc cross-compilation stages.
#
# It is responsible for:
#  - emitting Makefile fragments (tc_vars*.mk) consumed by cross-env.mk
#  - generating configuration files for build systems:
#      * Autotools
#      * CMake
#      * Meson (cross + native)
#      * Rust / Cargo
#
# The tc_vars files are generated once per toolchain and cached using a
# status cookie to avoid unnecessary regeneration.
#
# Generated files:
#  $(WORK_DIR)/tc_vars.mk
#      Core toolchain metadata and paths
#  $(WORK_DIR)/tc_vars.autotools.mk
#      Autotools cross-compilation variables (CC, CFLAGS, SYSROOT, …)
#  $(WORK_DIR)/tc_vars.flags.mk
#      Raw compiler and linker flags
#  $(WORK_DIR)/tc_vars.rust.mk
#      Rust / Cargo environment variables
#  $(WORK_DIR)/tc_vars.cmake
#      CMake toolchain definition file
#  $(WORK_DIR)/tc_vars.meson-cross
#      Meson cross file for target builds
#  $(WORK_DIR)/tc_vars.meson-native
#      Meson native file for in-build tools
#
# Targets are executed in the following order:
#  tcvars_msg
#  pre_tcvars_target    (override with PRE_TCVARS_TARGET)
#  tcvars_target        (override with TCVARS_TARGET)
#  post_tcvars_target   (override with POST_TCVARS_TARGET)
#
# Variables:
#  TCVARS_COOKIE    : Status cookie indicating tc_vars generation completion
#  TCVARS_SUBMAKE   : Internal flag to avoid recursive default goal execution
#
# Notes:
#  - This makefile only emits configuration files; it does not build anything.
#  - All output is written to $(WORK_DIR).
#  - tc_vars files are consumed by spksrc.cross/env-default.mk and package builds.
#  - The tcvars target is idempotent and skipped if the cookie exists.
#
###############################################################################

# Variables
COOKIE_PREFIX =

# Where a tool lives, emitted verbatim into tc_vars.mk below so the files written here
# and the packages reading them resolve one the same way. Recursive: the overlays follow.
TC_PATH                   = $(TC_WORK_DIR)/$(TC_TARGET)/bin/
TC_OVERLAY_BINUTILS_PATH  = $(if $(OVERLAY_BINUTILS_ON),$(OVERLAY_BINUTILS_BIN)/)
TC_OVERLAY_GCC_PATH       = $(if $(OVERLAY_GCC_ON),$(OVERLAY_GCC_BIN)/)

# The cmake variable a tool fills, given its TOOLS name; the build-host twin is the
# same with _FOR_BUILD appended. Anything not named here is CMAKE_<name>.
_cmake_var = $(strip \
  $(if $(filter CC,$(1)),CMAKE_C_COMPILER,\
  $(if $(filter CPP CXX,$(1)),CMAKE_$(1)_COMPILER,\
  $(if $(filter LD,$(1)),CMAKE_LINKER,\
  $(if $(filter LDSHARED,$(1)),CMAKE_SHARED_LINKER_FLAGS,\
  $(if $(filter FC,$(1)),CMAKE_Fortran_COMPILER,CMAKE_$(1)))))))

# One [binaries] line, from a TOOLS name $(1) and a tool path $(2). meson calls the C++
# compiler cpp, wants c beside cc and fortran rather than fc, and ldshared is a driver.
_meson_cross_entry = \
  $(if $(filter cpp,$(1)),echo "# Ref: https://mesonbuild.com/Machine-files.html#binaries" ; echo "cpp = '$(call tc,g++)'" ;,\
  $(if $(filter fc,$(1)),echo "fortran = '$(2)'" ;,\
  $(if $(filter cc,$(1)),echo "c = '$(2)'" ; echo "cc = '$(2)'" ;,\
  $(if $(filter ldshared,$(1)),echo "ldshared = '$(2) $(TC_LDSHARED_ARGS)'" ;,\
  echo "$(1) = '$(2)'" ;))))

# The same for the native machine file, where the tools are the host's own: no
# overlay to honour, and the shared link takes no target flags.
_meson_native_entry = \
  $(if $(filter cc,$(1)),echo "c = '$(2)'" ; echo "cc = '$(2)'" ;,\
  $(if $(filter fc,$(1)),echo "fortran = '$(2)'" ;,\
  $(if $(filter ldshared,$(1)),echo "ldshared = '$(2) -shared'" ;,\
  echo "$(1) = '$(2)'" ;)))

# Mark tc_vars generation as completed using status cookie
TCVARS_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)stage1-tcvars_done

#####

# Include cross-compilation definitions
# (provides arch-specific variables for toolchain generation)
include ../../mk/spksrc.cross/env-cmake.mk
include ../../mk/spksrc.cross/env-meson.mk
include ../../mk/spksrc.cross/env-rust.mk

#####

# Avoid looping when calling itself
ifeq ($(TCVARS_SUBMAKE),1)
.DEFAULT_GOAL :=
else
.DEFAULT_GOAL := tcvars
endif

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
	@mkdir -p $(WORK_DIR)
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

# Toolchain identity alone (TC_GCC, TC_TARGET, ...), the one file free of INSTALL_PREFIX and
# thus generatable from stage0's parse; the rest needs the recipe environment.
.PHONY: tcvars-identity
tcvars-identity: $(TC_VARS_MK)

#####

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
	@$(MSG) "Generating toolchain cross-compilation configuration files for $(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS)"

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
	$(foreach t,$(TOOLS),\
	  printf "set(%-25s %s)\n" $(call _cmake_var,$(call tool_var,$(t))) \
	    "$(if $(filter LDSHARED,$(call tool_var,$(t))),$(TC_LDSHARED_ARGS),$(call tc,$(call tool_bin,$(t))))" ; ) \
	echo
	@echo "# define 'build' compilers and tools to use" ; \
	$(foreach t,$(TOOLS),\
	  printf "set(%-35s %s)\n" $(call _cmake_var,$(call tool_var,$(t)))_FOR_BUILD \
	    "$(if $(filter LDSHARED,$(call tool_var,$(t))),-shared,$(call native,$(call tool_bin,$(t))))" ; ) \
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
	echo "set(CARGO  $(CARGO_HOME)/bin/cargo)" ; \
	echo "set(RUSTC  $(CARGO_HOME)/bin/rustc)"
	@echo ; \
	echo "# Cross target triple" ; \
	echo "set(RUST_TARGET  $(RUST_TARGET))" ; \
	echo "# cargo target for Corrosion (corrosion_import_crate), which cannot infer it" ; \
	echo "set(Rust_CARGO_TARGET  \$${RUST_TARGET})" ; \
	echo ; \
	echo "# Rust linker and AR" ; \
	echo "set(RUST_LINKER  \$${CMAKE_C_COMPILER})" ; \
	echo "set(RUST_AR      \$${CMAKE_AR})" ; \
	echo ; \
	echo "# Export Rust environment for Cargo builds" ; \
	echo "set(ENV{RUSTC} \$${RUSTC})" ; \
	echo "set(ENV{CARGO} \$${CARGO})" ; \
	echo "set(ENV{CARGO_BUILD_TARGET} \$${RUST_TARGET})" ; \
	echo "set(ENV{CARGO_TARGET_$(RUST_TARGET_UENV)_LINKER} \$${RUST_LINKER})" ; \
	echo "set(ENV{CARGO_TARGET_$(RUST_TARGET_UENV)_AR} \$${RUST_AR})" ; \
	echo "set(ENV{CARGO_TARGET_$(RUST_TARGET_UENV)_RUSTFLAGS} $(if $(OVERLAY_RUSTC_ON),,$(TC_EXTRA_RUSTFLAGS)))"

.PHONY: tc_meson_cross_vars
tc_meson_cross_vars:
	@echo "[host_machine]" ; \
	echo "system = 'linux'" ; \
	echo "cpu_family = '$(MESON_HOST_CPU_FAMILY)'" ; \
	echo "cpu = '$(MESON_HOST_CPU)'" ; \
	echo "endian = '$(MESON_HOST_ENDIAN)'"
	@echo
	@echo "[binaries]" ; \
	$(foreach t,$(TOOLS),$(call _meson_cross_entry,$(call tool_role,$(t)),$(call tc,$(call tool_bin,$(t))))) \
	true
	@echo "cargo = '$(CARGO_HOME)/bin/cargo'" ; \
	echo "rust = '$(CARGO_HOME)/bin/rustc'"

.PHONY: tc_meson_native_vars
tc_meson_native_vars:
	@echo "[binaries]"
	@$(foreach t,$(TOOLS),$(call _meson_native_entry,$(call tool_role,$(t)),$(call native,$(call tool_bin,$(t))))) \
	true
	@echo "g-ir-compiler = '$$(which g-ir-compiler)'" ; \
        echo "g-ir-generate = '$$(which g-ir-generate)'" ; \
        echo "g-ir-scanner = '$$(which g-ir-scanner)'"

# cc-rs CC_/CXX_/AR_/RANLIB_<rust triple>: TARGET_CC is ignored on x64 (host == target
# triple), and underscored since dash drops hyphenated names from the environment.
# RUST_TARGET, TC_RUSTC and TC_RUSTUP_TOOLCHAIN are emitted as make variables: this
# fragment is what every cross package reads them from, so a package calling cargo
# itself needs no rust mk of its own.
.PHONY: tc_rust_vars
tc_rust_vars:
	@# Target rustflags go through CARGO_TARGET_<triple>_RUSTFLAGS, never a global
	@# RUSTFLAGS: cargo ranks the global one higher, so it would silently drop the arch
	@# codegen options ($(TC_EXTRA_RUSTFLAGS): -Ctarget-cpu / -Ctarget-feature, e.g. ppc
	@# SPE) and put the target sysroot link-args on host build scripts and proc-macros.
	@# Consolidated here -- link-args, arch codegen, debug ADDITIONAL_RUSTFLAGS -- they
	@# reach the target alone. TC_EXTRA_RUSTFLAGS is skipped under the rust overlay,
	@# whose JSON spec carries cpu/features already; re-passing them makes rustc warn.
	@# The C flags work the same, one layer down: cc-rs prefers CFLAGS_<triple> and
	@# HOST_CFLAGS over a bare CFLAGS it would otherwise use for both sides. HOST_C*FLAGS
	@# are empty, the host wanting no target sysroot; ADDITIONAL_C*FLAGS stay deferred.
	@#
	@# HOST_* names the build machine, and is emitted only where that machine's triple
	@# differs from the target's -- so everywhere but x64, where the two are the same
	@# string. A build script that answers "am I cross compiling?" by comparing them
	@# (aws-lc-sys: cargo_env("HOST") != target()) then reads HOST_CC and HOST_CFLAGS as
	@# if they described the target, and overwrites CC_<triple> and CFLAGS_<triple> with
	@# them. Its bcm.c is compiled by the build machine's gcc against the build machine's
	@# headers, where _GNU_SOURCE over glibc >= 2.38 redirects sscanf and strtol to
	@# __isoc23_*, which no DSM sysroot carries (glibc 2.26 on 7.1), and the link ends on
	@# those two symbols. Left unsaid, the per-triple names stand: the target gets the
	@# cross compiler, and so does a host-side crate on x64 -- the same arch, built
	@# against an older sysroot, which is what it had before HOST_* existed.
	@echo TC_ENV += CARGO_HOME=\"$(realpath $(CARGO_HOME))\" ; \
	echo TC_ENV += RUSTUP_HOME=\"$(realpath $(RUSTUP_HOME))\" ; \
	echo TC_ENV += RUSTUP_TOOLCHAIN=\"$(TC_RUSTUP_TOOLCHAIN)\" ; \
	echo TC_ENV += RUST_TARGET_PATH=\"$(RUSTUP_HOME)/toolchains/$(TC_RUSTUP_TOOLCHAIN)/target-spec\" ; \
	echo TC_ENV += CARGO_BUILD_TARGET=\"$(RUST_TARGET)\" ; \
	echo TC_ENV += CARGO_TARGET_$(RUST_TARGET_UENV)_AR=\"$(call tc,ar)\" ; \
	echo TC_ENV += CARGO_TARGET_$(RUST_TARGET_UENV)_LINKER=\"$(call tc,gcc)\" ; \
	echo TC_ENV += CARGO_TARGET_$(RUST_TARGET_UENV)_RUSTFLAGS=\"$(RUSTFLAGS) $(if $(OVERLAY_RUSTC_ON),,$(TC_EXTRA_RUSTFLAGS)) $$\(ADDITIONAL_RUSTFLAGS\)\" ; \
	echo TC_ENV += CC_$(RUST_TARGET_LENV)=\"$(call tc,gcc)\" ; \
	echo TC_ENV += CXX_$(RUST_TARGET_LENV)=\"$(call tc,g++)\" ; \
	echo TC_ENV += AR_$(RUST_TARGET_LENV)=\"$(call tc,ar)\" ; \
	echo TC_ENV += RANLIB_$(RUST_TARGET_LENV)=\"$(call tc,ranlib)\" ; \
	echo TC_ENV += CFLAGS_$(RUST_TARGET_LENV)=\"$(CFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CFLAGS\)\" ; \
	echo TC_ENV += CXXFLAGS_$(RUST_TARGET_LENV)=\"$(CXXFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CXXFLAGS\)\"
ifneq ($(RUST_TARGET),$(RUST_BUILD_TRIPLE))
	@echo TC_ENV += HOST_CC=\"$(call native,gcc)\" ; \
	echo TC_ENV += HOST_CXX=\"$(call native,g++)\" ; \
	echo TC_ENV += HOST_AR=\"$(call native,ar)\" ; \
	echo TC_ENV += HOST_RANLIB=\"$(call native,ranlib)\" ; \
	echo TC_ENV += HOST_CFLAGS=\"\" ; \
	echo TC_ENV += HOST_CXXFLAGS=\"\"
endif
	@echo TC_ENV += CARGO_TERM_COLOR=\"never\" ; \
	echo TC_ENV += CARGO_TERM_PROGRESS_WHEN=\"never\" ; \
	echo RUST_TARGET := $(RUST_TARGET) ; \
	echo TC_RUSTC := $(TC_RUSTC) ; \
	echo TC_RUSTUP_TOOLCHAIN := $(TC_RUSTUP_TOOLCHAIN)

# The build/host split autoconf actually uses. With --host=<triple> the *bare* CC, CFLAGS
# and LDFLAGS below are the host's -- autoconf's host being the machine the output runs on,
# which is our target -- so they stay as they are. Drop them and AC_PROG_CC probes for
# itself: no <triple>-gcc on PATH, so it settles on /usr/bin/gcc and configures a native
# build that looks like it worked.
#
# What was missing is the other axis, the build machine, which autoconf spells *_FOR_BUILD
# and reads for a generator a package compiles and runs during the build. Having no name
# for it, each package that needs one invented its own: cross/bind_9.* says BUILD_CC,
# cross/cyrus-sasl patches CC_FOR_BUILD into a Makefile.in, cross/ffmpeg* passes
# --host-cc. The standard names are emitted here once, so a package can ask instead of
# improvise. The flags are empty on purpose, as HOST_CFLAGS is in the rust fragment above:
# the build machine wants none of the target's.
#
# No TARGET_*: --target and CC_FOR_TARGET mean something only for a package that is itself
# a compiler, and autoconf warns when they reach anything else.
.PHONY: tc_autotools_vars
tc_autotools_vars:
	@echo TC_CONFIGURE_ARGS := --host=$(TC_TARGET) --build=i686-pc-linux ; \
	echo TC_ENV += SYSROOT=\"$(TC_WORK_DIR)/$(TC_TARGET)/$(TC_SYSROOT)\" ; \
	$(foreach t,$(TOOLS),\
	  echo TC_ENV += $(call tool_var,$(t))=\"$(call tc,$(call tool_bin,$(t)))$(if \
	       $(filter LDSHARED,$(call tool_var,$(t))), $(TC_LDSHARED_ARGS))\" ; ) \
	echo TC_ENV += CFLAGS=\"$(CFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CFLAGS\)\" ; \
	echo TC_ENV += CPPFLAGS=\"$(CPPFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CPPFLAGS\)\" ; \
	echo TC_ENV += CXXFLAGS=\"$(CXXFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CXXFLAGS\)\" ; \
	if [ -n "$(TC_HAS_FORTRAN)" ]; then \
	   echo TC_ENV += FFLAGS=\"$(FFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_FFLAGS\)\" ; \
	fi ; \
	echo TC_ENV += LDFLAGS=\"$(LDFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(ADDITIONAL_LDFLAGS\)\" ; \
	echo TC_ENV += CC_FOR_BUILD=\"$(call native,gcc)\" ; \
	echo TC_ENV += CXX_FOR_BUILD=\"$(call native,g++)\" ; \
	echo TC_ENV += CPP_FOR_BUILD=\"$(call native,cpp)\" ; \
	echo TC_ENV += CFLAGS_FOR_BUILD=\"\" ; \
	echo TC_ENV += CXXFLAGS_FOR_BUILD=\"\" ; \
	echo TC_ENV += CPPFLAGS_FOR_BUILD=\"\" ; \
	echo TC_ENV += LDFLAGS_FOR_BUILD=\"\"

.PHONY: tc_flags
tc_flags:
	@echo CFLAGS := $(CFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CFLAGS\) ; \
	echo CPPFLAGS := $(CPPFLAGS) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CPPFLAGS\) ; \
	echo CXXFLAGS := $(CXXFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_CXXFLAGS\) ; \
	if [ -n "$(TC_HAS_FORTRAN)" ]; then \
	   echo FFLAGS := $(FFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(GCC_DEBUG_FLAGS\) $$\(ADDITIONAL_FFLAGS\) ; \
	fi ; \
	echo LDFLAGS := $(LDFLAGS) $(OVERLAY_BINUTILS_FLAG) $$\(ADDITIONAL_LDFLAGS\)

.PHONY: tc_vars
# TC_OVERLAY_<c> is emitted with ACTIVE semantics -- the consumer dir when the overlay drives
# THIS build, empty otherwise -- so a generated tc_vars.mk shows what was resolved. (In-tree the
# same names mean AVAILABLE; nothing on the package side reads them back.) Binutils counts as
# active only for the GLOBAL overlay: the narrow rust-link use downloads the same archive but
# touches nothing else, and shows up as a -Clink-arg=-B<shim> in the Rust link flags.
# TC_OVERLAY_<c>_PATH is the bin dir of an ACTIVE overlay, empty otherwise, so a package
# can write its own fallback -- see the tc macro in spksrc.common/macros.mk, which is what
# packages should call rather than assembling a path. Trailing slash, like TC_PATH.
#
# The GCC arm is inert today: no gcc overlay exists yet, so OVERLAY_GCC_ON is undefined and
# the value comes out empty. It is emitted anyway so the contract is whole and a gcc
# overlay needs no change here to switch it on.
#
# The OVERLAY_<c> switches are deliberately NOT emitted: a package includes this file, so it
# would inherit the previous run's choice and the switch would go sticky.
#
# TC_BINUTILS sits beside TC_GCC, TC_GLIBC and TC_KERNEL, the four a toolchain declares:
# it was the one missing here, so a package reading the generated file saw an empty value
# where the other three were there. Emitted as the version this build will use -- the
# overlay's as/ld when that is what every compile goes through, like TC_GCC under a gcc
# overlay -- through the same macro tc-capability.mk resolves a package's with.
tc_vars:
	@echo TC_TYPE := $(TC_TYPE) ; \
	echo TC_WORK_DIR := $(TC_WORK_DIR) ; \
	echo TC_SYSROOT := $(TC_SYSROOT) ; \
	echo TC_TARGET := $(TC_TARGET) ; \
	echo TC_PREFIX := $(TC_PREFIX) ; \
	echo TC_PATH := $(TC_PATH) ; \
	echo TC_INCLUDE := $(TC_INCLUDE) ; \
	echo TC_LIBRARY := $(TC_LIBRARY) ; \
	echo TC_EXTRA_BUILD_FLAGS := $(TC_EXTRA_BUILD_FLAGS) ; \
	echo TC_EXTRA_CFLAGS := $(TC_EXTRA_CFLAGS) ; \
	echo TC_EXTRA_CPPFLAGS := $(TC_EXTRA_CPPFLAGS) ; \
	echo TC_EXTRA_CXXFLAGS := $(TC_EXTRA_CXXFLAGS) ; \
	echo TC_EXTRA_FFLAGS := $(TC_EXTRA_FFLAGS) ; \
	echo TC_EXTRA_LDFLAGS := $(TC_EXTRA_LDFLAGS) ; \
	echo TC_EXTRA_RUSTFLAGS := $(if $(OVERLAY_RUSTC_ON),,$(TC_EXTRA_RUSTFLAGS)) ; \
	echo TC_VERS := $(TC_VERS) ; \
	echo TC_BUILD := $(TC_BUILD) ; \
	echo TC_OS_MIN_VER := $(TC_OS_MIN_VER) ; \
	echo TC_ARCH := $(TC_ARCH) ; \
	echo TC_GCC := $(TC_GCC) ; \
	echo TC_GLIBC := $(TC_GLIBC) ; \
	echo TC_BINUTILS := $(call overlay_binutils_vers,$(TC_BINUTILS)) ; \
	echo TC_OVERLAY_RUSTC := $(if $(OVERLAY_RUSTC_ON),$(TC_OVERLAY_RUSTC)) ; \
	echo TC_OVERLAY_BINUTILS := $(if $(OVERLAY_BINUTILS_ON),$(TC_OVERLAY_BINUTILS)) ; \
	echo TC_OVERLAY_BINUTILS_PATH := $(TC_OVERLAY_BINUTILS_PATH) ; \
	echo TC_OVERLAY_GCC_PATH := $(TC_OVERLAY_GCC_PATH)
# TC_KERNEL is emitted just below, with the ">= 4.4" EXTRAVERSION "+" handling.
# Add "+" to EXTRAVERSION for kernels version >= 4.4
ifeq ($(call version_ge, ${TC_KERNEL}, 4.4),1)
	@echo TC_KERNEL := $(TC_KERNEL)+
else
	@echo TC_KERNEL := $(TC_KERNEL)
endif

#####

ifeq ($(wildcard $(TCVARS_COOKIE)),)
tcvars: overlay-binutils-warn overlay-rustc-warn generate_tc_vars_mk generate_tc_vars_other $(TCVARS_COOKIE)

$(TCVARS_COOKIE): $(POST_TCVARS_TARGET)
	$(create_target_dir)
	@touch -f $@

else
tcvars: ;
endif

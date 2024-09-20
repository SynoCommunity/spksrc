
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(CURDIR)/work
include ../../mk/spksrc.directories.mk

include ../../mk/spksrc.common.mk

### Include common rules
include ../../mk/spksrc.common-rules.mk

# Include ross-rust-env.mk to generate install its toolchain
include ../../mk/spksrc.cross-rust-env.mk

# Include cross-cmake-env.mk to generate its toolchain file
include ../../mk/spksrc.cross-cmake-env.mk

# Include cross-meson-env.mk to generate its toolchain file
include ../../mk/spksrc.cross-meson-env.mk

# Configure the included makefiles
URLS                = $(TC_DIST_SITE)/$(TC_DIST_NAME)
NAME                = $(TC_NAME)
COOKIE_PREFIX       = 
ifneq ($(TC_DIST_FILE),)
LOCAL_FILE          = $(TC_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE       = $(TC_DIST_FILE)
else
LOCAL_FILE          = $(TC_DIST_NAME)
endif
DISTRIB_DIR         = $(TOOLCHAIN_DIR)/$(TC_VERS)
DIST_FILE           = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT            = $(TC_EXT)
TC_LOCAL_VARS_MK    = $(WORK_DIR)/tc_vars.mk
TC_LOCAL_VARS_CMAKE = $(WORK_DIR)/tc_vars.cmake
TC_LOCAL_VARS_MESON = $(WORK_DIR)/tc_vars.meson

#####

RUN = cd $(WORK_DIR)/$(TC_TARGET) && env $(ENV)

include ../../mk/spksrc.depend.mk

download:
include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

fix: extract
include ../../mk/spksrc.tc-fix.mk

patch: fix
include ../../mk/spksrc.patch.mk

vers: patch
include ../../mk/spksrc.tc-vers.mk

flag: vers
include ../../mk/spksrc.tc-flags.mk

rustc: flag
include ../../mk/spksrc.tc-rust.mk

all: rustc depend $(TC_LOCAL_VARS_CMAKE) $(TC_LOCAL_VARS_MESON) $(TC_LOCAL_VARS_MK)

.PHONY: $(TC_LOCAL_VARS_MK)
$(TC_LOCAL_VARS_MK):
	env $(MAKE) --no-print-directory tc_vars > $@ 2>/dev/null;

.PHONY: $(TC_LOCAL_VARS_CMAKE)
$(TC_LOCAL_VARS_CMAKE): 
	env $(MAKE) --no-print-directory cmake_vars > $@ 2>/dev/null;

.PHONY: $(TC_LOCAL_VARS_MESON)
$(TC_LOCAL_VARS_MESON): 
	env $(MAKE) --no-print-directory meson_vars > $@ 2>/dev/null;

.PHONY: cmake_vars
cmake_vars:
	@echo "# the name of the target operating system" ; \
	echo "set(CMAKE_SYSTEM_NAME $(CMAKE_SYSTEM_NAME))" ; \
	echo
	@echo "# define target processor" ; \
	echo "set(CMAKE_SYSTEM_PROCESSOR $(CMAKE_SYSTEM_PROCESSOR))"
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
	@echo "set(CROSS_COMPILE_ARM $(CROSS_COMPILE_ARM))"
else ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
	@echo "set(ARCH $(CMAKE_ARCH))"
endif
	@echo
	@echo "# define toolchain location (used with CMAKE_TOOLCHAIN_PKG)" ; \
	echo "set(_CMAKE_TOOLCHAIN_LOCATION $(_CMAKE_TOOLCHAIN_LOCATION))" ; \
	echo "set(_CMAKE_TOOLCHAIN_PREFIX $(_CMAKE_TOOLCHAIN_PREFIX))" ; \
	echo
	@echo "# define compilers and tools to use" ; \
	for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/' | tr [:lower:] [:upper:] ) ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/' ) ; \
	  if [ "$${target}" = "CC" ] ; then \
	    echo "set(CMAKE_C_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source})" ; \
	  elif [ "$${target}" = "CPP" -o "$${target}" = "CXX" ] ; then \
	    echo "set(CMAKE_$${target}_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source})" ; \
	  elif [ "$${target}" = "LD" ] ; then \
	    echo "set(CMAKE_LINKER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source})" ; \
	  else \
	    echo "set(CMAKE_$${target} $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source})" ; \
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

.PHONY: meson_vars
meson_vars:
	@echo "[built-in]" ; \
	echo "c_args = ['$(MESON_BUILTIN_C_ARGS)']" ; \
	echo "c_link_args = ['$(MESON_BUILTIN_C_LINK_ARGS)']" ; \
	echo "cpp_args = ['$(MESON_BUILTIN_CPP_ARGS)']" ; \
	echo "cpp_link_args = ['$(MESON_BUILTIN_CPP_LINK_ARGS)']"
	@echo
	@echo "[host_machine]" ; \
	echo "system = 'linux'" ; \
	echo "cpu_family = '$(MESON_HOST_CPU_FAMILY)'" ; \
	echo "cpu = '$(MESON_HOST_CPU)'" ; \
	echo "endian = '$(MESON_HOST_ENDIAN)'"

.PHONY: tc_vars
tc_vars: flag
	@echo TC_ENV := ; \
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
	echo TC_ENV += CFLAGS=\"$(CFLAGS) $$\(ADDITIONAL_CFLAGS\)\" ; \
	echo TC_ENV += CPPFLAGS=\"$(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\)\" ; \
	echo TC_ENV += CXXFLAGS=\"$(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\)\" ; \
	echo TC_ENV += LDFLAGS=\"$(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)\" ; \
	echo TC_ENV += CARGO_HOME=\"$(realpath $(CARGO_HOME))\" ; \
	echo TC_ENV += RUSTUP_HOME=\"$(realpath $(RUSTUP_HOME))\" ; \
	echo TC_ENV += RUSTUP_TOOLCHAIN=\"$(TC_RUSTUP_TOOLCHAIN)\" ; \
	echo TC_ENV += CARGO_BUILD_TARGET=\"$(RUST_TARGET)\" ; \
	echo TC_ENV += CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_AR=\"$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)ar\" ; \
	echo TC_ENV += CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_LINKER=\"$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc\" ; \
	echo TC_ENV += CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_RUSTFLAGS=\"$(TC_RUSTFLAGS) $$\(ADDITIONAL_RUSTFLAGS\)\" ; \
	echo TC_CONFIGURE_ARGS := --host=$(TC_TARGET) --build=i686-pc-linux ; \
	echo TC_TYPE := $(TC_TYPE) ; \
	echo TC_SYSROOT := $(WORK_DIR)/$(TC_TARGET)/$(TC_SYSROOT) ; \
	echo TC_TARGET := $(TC_TARGET) ; \
	echo TC_PREFIX := $(TC_PREFIX) ; \
	echo TC_PATH := $(WORK_DIR)/$(TC_TARGET)/bin/ ; \
	echo CFLAGS := $(CFLAGS) $$\(ADDITIONAL_CFLAGS\) ; \
	echo CPPFLAGS := $(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\) ; \
	echo CXXFLAGS := $(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\) ; \
	echo LDFLAGS := $(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\) ; \
	echo TC_INCLUDE := $(TC_INCLUDE) ; \
	echo TC_LIBRARY := $(TC_LIBRARY) ; \
	echo TC_EXTRA_CFLAGS := $(TC_EXTRA_CFLAGS) ; \
	echo TC_VERS := $(TC_VERS) ; \
	echo TC_BUILD := $(TC_BUILD) ; \
	echo TC_OS_MIN_VER := $(TC_OS_MIN_VER) ; \
	echo TC_ARCH := $(TC_ARCH) ; \
	echo TC_GCC := $${gcc_version} ; \
	echo TC_GLIBC := $(TC_GLIBC)
# Add "+" to EXTRAVERSION for kernels version >= 4.4
ifeq ($(call version_ge, ${TC_KERNEL}, 4.4),1)
	@echo TC_KERNEL := $(TC_KERNEL)+
else
	@echo TC_KERNEL := $(TC_KERNEL)
endif

### For make digests
include ../../mk/spksrc.generate-digests.mk

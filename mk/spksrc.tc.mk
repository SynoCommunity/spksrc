
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk

include ../../mk/spksrc.common.mk

# Include cross-cmake-env.mk to generate its toolchain file
include ../../mk/spksrc.cross-cmake-env.mk

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

#####

RUN = cd $(WORK_DIR)/$(TC_TARGET) && env $(ENV)

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

vers: patch
include ../../mk/spksrc.tc-vers.mk

flag: vers
include ../../mk/spksrc.tc-flags.mk

fix: flag
include ../../mk/spksrc.tc-fix.mk

all: fix $(TC_LOCAL_VARS_CMAKE) $(TC_LOCAL_VARS_MK)

.PHONY: $(TC_LOCAL_VARS_MK)
$(TC_LOCAL_VARS_MK): fix
	env $(MAKE) --no-print-directory tc_vars > $@ 2>/dev/null;

.PHONY: $(TC_LOCAL_VARS_CMAKE)
$(TC_LOCAL_VARS_CMAKE): fix
	env $(MAKE) --no-print-directory cmake_vars > $@ 2>/dev/null;

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
	@echo "# which compilers to use" ; \
	echo "set(_CMAKE_TOOLCHAIN_LOCATION $(_CMAKE_TOOLCHAIN_LOCATION))" ; \
	echo "set(_CMAKE_TOOLCHAIN_PREFIX $(_CMAKE_TOOLCHAIN_PREFIX))" ; \
	echo
	@echo "set(CMAKE_C_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc)" ; \
	echo "set(CMAKE_CPP_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)cpp)" ; \
	echo "set(CMAKE_CXX_COMPILER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)c++)" ; \
	echo "set(CMAKE_LINKER $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)ld)" ; \
	echo "set(CMAKE_AR $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)ar)" ; \
	echo "set(CMAKE_AS $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)as)" ; \
	echo "set(CMAKE_NM $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)nm)" ; \
	echo "set(CMAKE_OBJDUMP $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)objdump)" ; \
	echo "set(CMAKE_RANLIB $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)ranlib)" ; \
	echo "set(CMAKE_READELF $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)readelf)" ; \
	echo "set(CMAKE_STRIP $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)strip)" ; \
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
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE $(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE))" ; \
	echo ; \
	echo "# always build shared library" ; \
	echo "set(BUILD_SHARED_LIBS $(BUILD_SHARED_LIBS))"

.PHONY: tc_vars
tc_vars:
	@echo TC_ENV := ; \
	for tool in $(TOOLS) ; \
	do \
	  target=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\1/') ; \
	  source=$$(echo $${tool} | sed 's/\(.*\):\(.*\)/\2/') ; \
	  echo TC_ENV += $$(echo $${target} | tr [:lower:] [:upper:] )=\"$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source}\" ; \
	  if [ "$${target}" = "cc" ] ; then \
	    gcc_version=$$(eval $$(echo $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source} -dumpversion) 2>/dev/null || true) ; \
	  fi ; \
	done ; \
	echo TC_ENV += CFLAGS=\"$(CFLAGS) $$\(ADDITIONAL_CFLAGS\)\" ; \
	echo TC_ENV += CPPFLAGS=\"$(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\)\" ; \
	echo TC_ENV += CXXFLAGS=\"$(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\)\" ; \
	echo TC_ENV += LDFLAGS=\"$(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)\" ; \
	echo TC_CONFIGURE_ARGS := --host=$(TC_TARGET) --build=i686-pc-linux ; \
	echo TC_TYPE := $(TC_TYPE) ; \
	echo TC_TARGET := $(TC_TARGET) ; \
	echo TC_PREFIX := $(TC_PREFIX) ; \
	echo TC_PATH := $(WORK_DIR)/$(TC_TARGET)/bin/ ; \
	echo CFLAGS := $(CFLAGS) $$\(ADDITIONAL_CFLAGS\) ; \
	echo CPPFLAGS := $(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\) ; \
	echo CXXFLAGS := $(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\) ; \
	echo LDFLAGS := $(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\) ; \
	echo TC_LIBRARY := $(TC_LIBRARY) ; \
	echo TC_INCLUDE := $(TC_INCLUDE) ; \
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

### Clean rules
clean:
	rm -fr $(WORK_DIR)

### For make digests
include ../../mk/spksrc.generate-digests.mk

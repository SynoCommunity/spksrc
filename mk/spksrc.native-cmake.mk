# Build native CMake programs
#
# This makefile extends spksrc.native-cc.mk with CMake-specific functionality
#

# Package dependent (same as native-cc.mk)
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

# Setup common directories
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

# cmake specific configurations
include ../../mk/spksrc.native-cmake-env.mk

#####

# configure using cmake
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = cmake_configure_target
endif

# source directory
ifeq ($(strip $(CMAKE_SOURCE_DIR)),)
CMAKE_SOURCE_DIR = $(CMAKE_BASE_DIR)
endif

# install
ifeq ($(strip $(CMAKE_DIR)),)
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

ifeq ($(strip $(CMAKE_USE_NINJA)),1)
include ../../mk/spksrc.ninja.mk
else
# compile
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = cmake_compile_target
endif

# install
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = cmake_install_target
endif
endif

#####

# CMake specific targets
.PHONY: cmake_configure_target

# default cmake configure:
cmake_configure_target:
	@$(MSG) - CMake configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
	@$(MSG)    - Use DESTDIR = $(CMAKE_USE_DESTDIR)
	@$(MSG)    - Path DESTDIR = $(CMAKE_DESTDIR)
	@$(MSG)    - Path BUILD_DIR = $(CMAKE_BUILD_DIR)
	@$(MSG)    - Path CMAKE_SOURCE_DIR = $(CMAKE_SOURCE_DIR)
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(CMAKE_BUILD_DIR)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) cmake -S $(CMAKE_SOURCE_DIR) -B $(CMAKE_BUILD_DIR) $(CMAKE_ARGS) $(ADDITIONAL_CMAKE_ARGS) $(CMAKE_DIR)

.PHONY: cmake_compile_target

# default compile:
cmake_compile_target:
	@$(MSG) - CMake compile
	env $(ENV) cmake --build $(CMAKE_BUILD_DIR) -j $(NCPUS)

.PHONY: cmake_install_target

# default install:
cmake_install_target:
	@$(MSG) - CMake install
ifeq ($(strip $(CMAKE_USE_DESTDIR)),0)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) $(MAKE) install
else
	cd $(CMAKE_BUILD_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(CMAKE_DESTDIR)
endif

#####

# Include base native-cc makefile for common functionality
include ../../mk/spksrc.native-cc.mk

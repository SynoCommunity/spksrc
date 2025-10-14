# Build CMake programs
#
# prerequisites:
# - cross/module depends on cmake
#
# remarks:
# - most content is taken from spksrc.cross-cc.mk and modified for cmake
#

# Common makefiles
include ../../mk/spksrc.common.mk

# Configure the included makefiles
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

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.directories.mk

###

# cmake specific configurations
include ../../mk/spksrc.cross-cmake-env.mk

# meson toolchain-file usage definition
include ../../mk/spksrc.cross-cmake-toolchainfile.mk

# configure using cmake
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = cmake_configure_target
endif

# source directory
ifeq ($(strip $(CMAKE_SOURCE_DIR)),)
CMAKE_SOURCE_DIR = $(CMAKE_BASE_DIR)
endif

ifeq ($(strip $(CMAKE_USE_NINJA)),1)
include ../../mk/spksrc.cross-ninja.mk
else
# compile
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = cmake_compile_target
endif

# install
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = cmake_install_target
endif

# post-install
ifeq ($(strip $(GCC_NO_DEBUG_INFO)),1)
ifeq ($(strip $(POST_INSTALL_TARGET)),)
POST_INSTALL_TARGET = cmake_post_install_target
endif
endif
endif

###

include ../../mk/spksrc.pre-check.mk

include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

configure: patch
include ../../mk/spksrc.configure.mk

compile: configure
include ../../mk/spksrc.compile.mk

install: compile
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

all: install plist

###

.PHONY: cmake_configure_target
cmake_configure_target: $(CMAKE_TOOLCHAIN_FILE_PKG)
	@$(MSG) - CMake configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Optional Dependencies = $(OPTIONAL_DEPENDS)
	@$(MSG)    - Use Toolchain File = $(CMAKE_USE_TOOLCHAIN_FILE) [$(CMAKE_TOOLCHAIN_FILE_PKG)]
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
	@$(MSG)    - Use DESTDIR = $(CMAKE_USE_DESTDIR)
	@$(MSG)    - CMake = $(shell which cmake) [$(shell cmake --version | head -1 | awk '{print $$NF}')]
	@$(MSG)    - Path DESTDIR = $(CMAKE_DESTDIR)
	@$(MSG)    - Path BUILD_DIR = $(CMAKE_BUILD_DIR)
	@$(MSG)    - Path CMAKE_SOURCE_DIR = $(CMAKE_SOURCE_DIR)
	@$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN_CMAKE) cmake -S $(CMAKE_SOURCE_DIR) -B $(CMAKE_BUILD_DIR) $(CMAKE_ARGS) $(ADDITIONAL_CMAKE_ARGS) $(CMAKE_DIR)

.PHONY: cmake_compile_target

# default compile:
cmake_compile_target:
	@$(MSG) - CMake compile
	@$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), NAME: $(NAME) >> $(PSTAT_LOG)
	$(RUN_CMAKE) cmake --build $(CMAKE_BUILD_DIR) -j $(NCPUS)

.PHONY: cmake_install_target

# default install:
cmake_install_target:
	@$(MSG) - CMake install
ifeq ($(strip $(CMAKE_USE_DESTDIR)),0)
	$(RUN_CMAKE) cmake --install $(CMAKE_BUILD_DIR)
else
	$(RUN_CMAKE) DESTDIR=$(CMAKE_DESTDIR) cmake --install $(CMAKE_BUILD_DIR)
endif

.PHONY: cmake_post_install_target

# default post-install: clean
# only called when GCC_NO_DEBUG_INFO=1
cmake_post_install_target:
	@$(MSG) - CMake post-install \(clean\)
	$(RUN_CMAKE) cmake --build $(CMAKE_BUILD_DIR) --target clean


### For arch-* and all-<supported|latest>
include ../../mk/spksrc.supported.mk

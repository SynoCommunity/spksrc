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
include ../../mk/spksrc.directories.mk

# cmake specific configurations
include ../../mk/spksrc.cross-cmake-env.mk

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
ifneq ($(ARCH),noarch)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
TC = syno$(ARCH_SUFFIX)
endif
endif

###

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

ifeq ($(strip $(CMAKE_USE_TOOLCHAIN_FILE)),ON)
CMAKE_ARGS += -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_PKG)
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

.PHONY: $(CMAKE_TOOLCHAIN_PKG)
$(CMAKE_TOOLCHAIN_PKG):
	@$(MSG) Generating $(CMAKE_TOOLCHAIN_PKG)
	env $(MAKE) --no-print-directory cmake_pkg_toolchain > $(CMAKE_TOOLCHAIN_PKG) 2>/dev/null;

.PHONY: cmake_pkg_toolchain
cmake_pkg_toolchain:
	@cat $(CMAKE_TOOLCHAIN_WRK) ; \
	echo
ifeq ($(strip $(CMAKE_USE_NASM)),1)
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
	@echo "# set assembly compiler" ; \
	echo "set(ENABLE_ASSEMBLY $(ENABLE_ASSEMBLY))" ; \
	echo "set(CMAKE_ASM_COMPILER $(CMAKE_ASM_COMPILER))" ; \
	echo
endif
endif
	@echo "# set compiler flags for cross-compiling" ; \
	echo 'set(CMAKE_C_FLAGS "$(CFLAGS) $(CMAKE_C_FLAGS) $(ADDITIONAL_CFLAGS)")' ; \
	echo 'set(CMAKE_CPP_FLAGS "$(CPPFLAGS) $(CMAKE_CPP_FLAGS) $(ADDITIONAL_CPPFLAGS)")' ; \
	echo 'set(CMAKE_CXX_FLAGS "$(CXXFLAGS) $(CMAKE_CXX_FLAGS) $(ADDITIONAL_CXXFLAGS)")'
ifneq ($(strip $(CMAKE_DISABLE_EXE_LINKER_FLAGS)),1)
	@echo 'set(CMAKE_EXE_LINKER_FLAGS "$(LDFLAGS) $(CMAKE_EXE_LINKER_FLAGS) $(ADDITIONAL_LDFLAGS)")'
endif
	@echo 'set(CMAKE_SHARED_LINKER_FLAGS "$(LDFLAGS) $(CMAKE_SHARED_LINKER_FLAGS) $(ADDITIONAL_LDFLAGS)")' ; \
	echo
ifneq ($(strip $(BUILD_SHARED_LIBS)),)
	@echo "# build shared library" ; \
	echo "set(BUILD_SHARED_LIBS $(BUILD_SHARED_LIBS))"
endif
	@echo "# define library rpath" ; \
	echo "set(CMAKE_INSTALL_RPATH $(subst $() $(),:,$(CMAKE_INSTALL_RPATH)))" ; \
	echo "set(CMAKE_INSTALL_RPATH_USE_LINK_PATH $(CMAKE_INSTALL_RPATH_USE_LINK_PATH))" ; \
	echo "set(CMAKE_BUILD_WITH_INSTALL_RPATH $(CMAKE_BUILD_WITH_INSTALL_RPATH))" ; \
	echo
	@echo "# set pkg-config path" ; \
	echo 'set(ENV{PKG_CONFIG_LIBDIR} "$(abspath $(PKG_CONFIG_LIBDIR))")'

.PHONY: cmake_configure_target
cmake_configure_target: $(CMAKE_TOOLCHAIN_PKG)
	@$(MSG) - CMake configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Optional Dependencies = $(OPTIONAL_DEPENDS)
	@$(MSG)    - Use Toolchain File = $(CMAKE_USE_TOOLCHAIN_FILE) [$(CMAKE_TOOLCHAIN_PKG)]
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
	@$(MSG)    - Use DESTDIR = $(CMAKE_USE_DESTDIR)
	@$(MSG)    - CMake = $(shell which cmake) [$(shell cmake --version | head -1 | awk '{print $$NF}')]
	@$(MSG)    - Path DESTDIR = $(CMAKE_DESTDIR)
	@$(MSG)    - Path BUILD_DIR = $(CMAKE_BUILD_DIR)
	@$(MSG)    - Path CMAKE_SOURCE_DIR = $(CMAKE_SOURCE_DIR)
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) cmake -S $(CMAKE_SOURCE_DIR) -B $(CMAKE_BUILD_DIR) $(CMAKE_ARGS) $(ADDITIONAL_CMAKE_ARGS) $(CMAKE_DIR)

.PHONY: cmake_compile_target

# default compile:
cmake_compile_target:
	@$(MSG) - CMake compile
	@$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), NAME: $(NAME) >> $(PSTAT_LOG)
	$(RUN) cmake --build $(CMAKE_BUILD_DIR) -j $(NCPUS)

.PHONY: cmake_install_target

# default install:
cmake_install_target:
	@$(MSG) - CMake install
ifeq ($(strip $(CMAKE_USE_DESTDIR)),0)
	$(RUN) cmake --install $(CMAKE_BUILD_DIR)
else
	$(RUN) DESTDIR=$(CMAKE_DESTDIR) cmake --install $(CMAKE_BUILD_DIR)
endif

.PHONY: cmake_post_install_target

# default post-install: clean
# only called when GCC_NO_DEBUG_INFO=1
cmake_post_install_target:
	@$(MSG) - CMake post-install \(clean\)
	$(RUN) cmake --build $(CMAKE_BUILD_DIR) --target clean


### For arch-* and all-<supported|latest>
include ../../mk/spksrc.supported.mk

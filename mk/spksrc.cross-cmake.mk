# Build CMake programs
#
# prerequisites:
# - cross/module depends on cmake
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# cmake specific configurations
include ../../mk/spksrc.cross-cmake-env.mk

####

# configure using cmake
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = cmake_configure_target
endif

ifneq ($(strip $(CMAKE_USE_NINJA)),1)
# compile
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = cmake_compile_target
endif

# install
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = cmake_install_target
endif
endif

.PHONY: $(CMAKE_TOOLCHAIN_PKG)
$(CMAKE_TOOLCHAIN_PKG):
	@$(MSG) Generating $(CMAKE_TOOLCHAIN_PKG)
	env $(MAKE) --no-print-directory cmake_pkg_toolchain > $(CMAKE_TOOLCHAIN_PKG) 2>/dev/null;

.PHONY: cmake_pkg_toolchain
cmake_pkg_toolchain:
	@cat $(CMAKE_TOOLCHAIN_WRK) ; \
	echo
ifeq ($(strip $(CMAKE_USE_NASM)),1)
	@echo "# set assembly compiler" ; \
	echo "set(ENABLE_ASSEMBLY $(ENABLE_ASSEMBLY))" ; \
	echo "set(CMAKE_ASM_COMPILER $(CMAKE_ASM_COMPILER))" ; \
	echo
endif
	@echo "# set compiler flags for cross-compiling" ; \
	echo 'set(CMAKE_C_FLAGS "$(CFLAGS) $(CMAKE_C_FLAGS) $(ADDITIONAL_CFLAGS)")' ; \
	echo 'set(CMAKE_CPP_FLAGS "$(CPPFLAGS) $(CMAKE_CPP_FLAGS) $(ADDITIONAL_CPPFLAGS)")' ; \
	echo 'set(CMAKE_CXX_FLAGS "$(CXXFLAGS) $(CMAKE_CXX_FLAGS) $(ADDITIONAL_CXXFLAGS)")' ; \
	echo 'set(CMAKE_LD_FLAGS "$(LDFLAGS) $(CMAKE_LD_FLAGS) $(ADDITIONAL_LDFLAGS)")' ; \
	echo
	@echo "# define library rpath" ; \
	echo "set(CMAKE_INSTALL_RPATH $(subst $() $(),:,$(CMAKE_INSTALL_RPATH)))" ; \
	echo "set(CMAKE_INSTALL_RPATH_USE_LINK_PATH $(CMAKE_INSTALL_RPATH_USE_LINK_PATH))" ; \
	echo "set(CMAKE_BUILD_WITH_INSTALL_RPATH $(CMAKE_BUILD_WITH_INSTALL_RPATH))" ; \
	echo

.PHONY: cmake_configure_target

# default cmake configure:
cmake_configure_target: $(CMAKE_TOOLCHAIN_PKG)
	@$(MSG) - CMake configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Optional Dependencies = $(OPTIONAL_DEPENDS)
	@$(MSG)    - Use Toolchain File = $(CMAKE_USE_TOOLCHAIN_FILE) [$(CMAKE_TOOLCHAIN_PKG)]
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
	@$(MSG)    - Use DESTDIR = $(CMAKE_USE_DESTDIR)
	@$(MSG)    - Path DESTDIR = $(CMAKE_DESTDIR)
	@$(MSG)    - Path BUILD_DIR = $(CMAKE_BUILD_DIR)
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(CMAKE_BUILD_DIR)
ifeq ($(strip $(CMAKE_USE_TOOLCHAIN_FILE)),ON)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) cmake -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_PKG) $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)
else
	cd $(CMAKE_BUILD_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)
endif

.PHONY: cmake_compile_target

ifeq ($(strip $(CMAKE_USE_NINJA)),1)
include ../../mk/spksrc.cross-ninja.mk
else

# default compile:
cmake_compile_target:
	@$(MSG) - CMake compile
ifneq ($(filter 1 on ON,$(PSTAT)),)
	@$(MSG) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), NAME: $(NAME) >> $(PSTAT_LOG)
endif
	env $(ENV) $(PSTAT_TIME) cmake --build $(CMAKE_BUILD_DIR) -j $(NCPUS)

.PHONY: cmake_install_target

# default install:
cmake_install_target:
	@$(MSG) - CMake install
ifeq ($(strip $(CMAKE_USE_DESTDIR)),0)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) $(MAKE) install
else
	cd $(CMAKE_BUILD_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(CMAKE_DESTDIR)
endif
endif

# call-up regular build process
include ../../mk/spksrc.cross-cc.mk

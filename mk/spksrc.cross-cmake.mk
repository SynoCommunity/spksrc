# Build CMake programs
#
# prerequisites:
# - cross/module depends on cmake
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

##### cmake specific configurations
include ../../mk/spksrc.cross-cmake-env.mk

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

.PHONY: cmake_configure_target

# default cmake configure:
cmake_configure_target:
	@$(MSG) - CMake configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
	@$(MSG)    - Use DESTDIR = $(CMAKE_USE_DESTDIR)
	@$(MSG)    - Path DESTDIR = $(CMAKE_DESTDIR)
	@$(MSG)    - Path BUILD_DIR = $(CMAKE_BUILD_DIR)
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(CMAKE_BUILD_DIR)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)

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

# default isntall:
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

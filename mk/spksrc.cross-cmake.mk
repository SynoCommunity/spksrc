# Build go programs
# 
# prerequisites:
# - cross/module depends on cmake
# 
# remarks:
# - improvised from spksrc.cross-go.mk
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

# compile
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = cmake_compile_target
endif

# install
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = cmake_install_target
endif

.PHONY: cmake_configure_target

# default cmake configure:
cmake_configure_target:
	@$(MSG) - CMake configure
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(PKG_WORK_DIR)
	cd $(PKG_WORK_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)

.PHONY: cmake_compile_target

# default compile:
cmake_compile_target:
	@$(MSG) - CMake compile
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE)

.PHONY: cmake_install_target

# default isntall:
cmake_install_target:
	@$(MSG) - CMake install
ifeq ($(strip $(CMAKE_USE_DESTDIR)),0)
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install
endif
ifeq ($(strip $(CMAKE_USE_DESTDIR)),1)
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(CMAKE_DESTDIR)
endif

# call-up regular build process
include ../../mk/spksrc.cross-cc.mk

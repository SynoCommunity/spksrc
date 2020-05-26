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
	@$(MSG) - CMAKE configure
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(PKG_WORK_DIR)
	cd $(PKG_WORK_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)

.PHONY: cmake_compile_target

# default compile:
cmake_compile_target:
	@$(MSG) - CMAKE compile
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE)

.PHONY: cmake_install_target

# default isntall:
cmake_install_target:
	@$(MSG) - CMAKE install
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(INSTALL_DIR)

# call-up regular build process
include ../../mk/spksrc.cross-cc.mk

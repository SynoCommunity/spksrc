# Build CMake programs
#
# prerequisites:
# - cross/module depends on cmake
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Force build in native tool directrory, not cross directory.
WORK_DIR := $(PWD)/work-native

# Package dependend
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

#####

.NOTPARALLEL:

include ../../mk/spksrc.native-env.mk

##### cmake specific configurations
include ../../mk/spksrc.native-cmake-env.mk

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
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
	@$(MSG)    - Use DESTDIR = $(CMAKE_USE_DESTDIR)
	@$(MSG)    - Path DESTDIR = $(CMAKE_DESTDIR)
	@$(MSG)    - Path BUILD_DIR = $(CMAKE_BUILD_DIR)
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(CMAKE_BUILD_DIR)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)

.PHONY: cmake_compile_target

# default compile:
cmake_compile_target:
	@$(MSG) - CMake compile
	cd $(CMAKE_BUILD_DIR) && env $(ENV) $(MAKE)

.PHONY: cmake_install_target

# default isntall:
cmake_install_target:
	@$(MSG) - CMake install
ifeq ($(strip $(CMAKE_USE_DESTDIR)),0)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) $(MAKE) install
endif
ifeq ($(strip $(CMAKE_USE_DESTDIR)),1)
	cd $(CMAKE_BUILD_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(CMAKE_DESTDIR)
endif

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

.PHONY: cat_PLIST
cat_PLIST:
	@true

### Clean rules
clean:
	rm -fr $(WORK_DIR)

all: install

### For make digests
include ../../mk/spksrc.generate-digests.mk

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

####

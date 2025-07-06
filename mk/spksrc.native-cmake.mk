# Build native CMake programs
#
# remarks:
# - most content is taken from spksrc.native-cc.mk and modified for cmake
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# cmake specific configurations
include ../../mk/spksrc.native-cmake-env.mk

# Force build in native tool directrory, not cross directory.
WORK_DIR := $(CURDIR)/work-native

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

# configure using cmake
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = cmake_configure_target
endif

# install
ifeq ($(strip $(CMAKE_DIR)),)
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)
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
endif

###

.NOTPARALLEL:

# native specific environment
include ../../mk/spksrc.native-env.mk

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

all: install

###

# No PLIST to be processed for native
.PHONY: cat_PLIST
cat_PLIST:
	@true

###

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
	cd $(CMAKE_BUILD_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(CMAKE_DIR)

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

###

### Include common rules
include ../../mk/spksrc.common-rules.mk

####

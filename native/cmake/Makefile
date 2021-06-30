PKG_NAME = cmake
PKG_VERS = 3.20.5
PKG_EXT = sh
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-x86_64.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Kitware/CMake/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-installer

HOMEPAGE = https://cmake.org/
COMMENT  = CMake is an open-source, cross-platform family of tools designed to build, test and package software.
LICENSE  = OSI-approved BSD 3-Clause License

# download and execute installer script
EXTRACT_TARGET = cmake_native_extract
INSTALL_TARGET = cmake_native_install

include ../../mk/spksrc.native-install.mk

.PHONY: cmake_native_extract
cmake_native_extract:
	mkdir -p $(WORK_DIR)/$(PKG_DIR)
	cp -f $(DIST_FILE) $(WORK_DIR)/$(PKG_DIR)
	chmod +x $(WORK_DIR)/$(PKG_DIR)/$(PKG_DIST_NAME)

.PHONY: cmake_native_install
cmake_native_install:
	$(RUN) ./$(PKG_DIST_NAME) --skip-license --prefix=$(STAGING_INSTALL_PREFIX)

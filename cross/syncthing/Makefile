PKG_NAME = syncthing
PKG_VERS = 2.0.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-source-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/syncthing/syncthing/releases/download/v$(PKG_VERS)
PKG_DIR = src/github.com/$(PKG_NAME)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

# Staged output of cross/sqlite; used to source headers/libs for CGO build
SQLITE_PREFIX = $(abspath $(CURDIR)/../sqlite/work$(ARCH_SUFFIX)/install/usr/local/sqlite-autoconf)

BUILD_DEPENDS = native/go
DEPENDS = cross/sqlite

HOMEPAGE = https://www.syncthing.net/
COMMENT  = Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers.
LICENSE  = MPL-2.0

COMPILE_TARGET = syncthing_compile
INSTALL_TARGET = syncthing_install
POST_INSTALL_TARGET = syncthing_post_install

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk

BUILD_ARGS = -goos=$(GOOS) -goarch=$(GO_ARCH) -version=v$(PKG_VERS)

.PHONY: syncthing_compile
# CGO build links against native SQLite instead of modernc shim
# (must override default rule to wire in headers/libs and runtime rpath)
syncthing_compile:
	@$(MSG) - Ensure cross/sqlite runtime is staged before CGO build
	@$(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) --no-print-directory -C ../sqlite install >/dev/null
	cd $(GO_SRC_DIR) && env CGO_ENABLED=1 \
	  CGO_CFLAGS="-I$(SQLITE_PREFIX)/include" \
	  CGO_LDFLAGS="-L$(SQLITE_PREFIX)/lib -Wl,-rpath,\$$ORIGIN/../lib -Wl,--rpath-link,$(SQLITE_PREFIX)/lib -lsqlite3 -lz" \
	  PKG_CONFIG_PATH=$(SQLITE_PREFIX)/lib/pkgconfig \
	  $(filter-out GOARCH=% CGO_ENABLED=% PKG_CONFIG_PATH=%,$(ENV)) \
	  go run build.go $(BUILD_ARGS) build

.PHONY: syncthing_install
# Bundle Syncthing binary together with the libsqlite3 runtime we link against
syncthing_install:
	@$(MSG) - Install Syncthing binary and SQLite runtime
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(GO_BIN_DIR) $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	@cp -a $(SQLITE_PREFIX)/lib/libsqlite3.so* $(STAGING_INSTALL_PREFIX)/lib/
	@if [ -d $(SQLITE_PREFIX)/lib ]; then \
	  for so in libz.so libz.so.1 libz.so.*; do \
	    find $(SQLITE_PREFIX)/lib -maxdepth 1 -name "$$so" -exec cp -P {} $(STAGING_INSTALL_PREFIX)/lib/ \; ; \
	  done; \
	fi

.PHONY: syncthing_post_install
# Keep only the shared libs needed at runtime; drop dev files from dependency
syncthing_post_install:
	@$(MSG) - Trim SQLite build artifacts
	@rm -f $(STAGING_INSTALL_PREFIX)/bin/sqlite3
	@rm -rf $(STAGING_INSTALL_PREFIX)/include $(STAGING_INSTALL_PREFIX)/share $(STAGING_INSTALL_PREFIX)/var
	@rm -rf $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
	@if [ -d $(STAGING_INSTALL_PREFIX)/lib ]; then \
	  find $(STAGING_INSTALL_PREFIX)/lib -maxdepth 1 -type f ! -name 'libsqlite3.so*' ! -name 'libz.so*' -delete; \
	  find $(STAGING_INSTALL_PREFIX)/lib -maxdepth 1 -type l ! -name 'libsqlite3.so*' ! -name 'libz.so*' -delete; \
	fi

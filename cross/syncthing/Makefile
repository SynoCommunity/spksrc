PKG_NAME = syncthing
PKG_VERS = 2.0.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-source-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/syncthing/syncthing/releases/download/v$(PKG_VERS)
PKG_DIR = src/github.com/$(PKG_NAME)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

# syncthing v2.0 enables a CGO-backed SQLite database engine.  The legacy
# modernc/sqlite shim (pure Go) no longer satisfies upstream performance and
# feature expectations per Syncthing issue #9285.  We therefore lean on the
# existing cross/sqlite package to stage a glibc-compatible libsqlite3 that
# matches each DSM toolchain, then teach the syncthing build to link against it.
#
# `cross/sqlite` stages into this package's own install tree, which differs
# between direct cross builds (`.../usr/local/syncthing`) and spk builds
# (`.../var/packages/syncthing/target`).  `$(STAGING_INSTALL_PREFIX)` abstracts
# that detail, so rely on it everywhere we look for headers and libraries.
SQLITE_STAGING = $(STAGING_INSTALL_PREFIX)

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
# Override the stock cross-go compile rule so we can wire CGO to the staged
# sqlite headers/libs and bake an rpath that resolves inside the final SPK
# (`$ORIGIN/../lib`).  This keeps the Syncthing binary self-contained while
# letting DSM toolchains provide the correct glibc.
syncthing_compile:
	@$(MSG) - Ensure cross/sqlite runtime is staged before CGO build
	@if [ ! -d "$(SQLITE_STAGING)/lib" ]; then \
	  $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) --no-print-directory -C ../sqlite install >/dev/null; \
	fi
	@if [ ! -d "$(SQLITE_STAGING)/lib" ]; then \
	  echo "*** sqlite runtime missing after dependency build" >&2; \
	  exit 1; \
	fi; \
	cd $(GO_SRC_DIR) && env CGO_ENABLED=1 \
	  CGO_CFLAGS="-I$(SQLITE_STAGING)/include" \
	  CGO_LDFLAGS="-L$(SQLITE_STAGING)/lib -Wl,-rpath,\$$ORIGIN/../lib -Wl,--rpath-link,$(SQLITE_STAGING)/lib -lsqlite3 -lz" \
	  PKG_CONFIG_PATH=$(SQLITE_STAGING)/lib/pkgconfig \
	  $(filter-out GOARCH=% CGO_ENABLED=% PKG_CONFIG_PATH=%,$(ENV)) \
	  go run build.go $(BUILD_ARGS) build

.PHONY: syncthing_install
# Drop the compiled binary alongside the shared libraries we just linked so the
# Runtime package contains everything needed to load SQLite on DSM.
syncthing_install:
	@$(MSG) - Install Syncthing binary and SQLite runtime
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(GO_BIN_DIR) $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	@if [ ! -d "$(SQLITE_STAGING)/lib" ]; then \
	  echo "*** sqlite runtime missing prior to install" >&2; \
	  exit 1; \
	fi; \
	cp -a $(SQLITE_STAGING)/lib/libsqlite3.so* $(STAGING_INSTALL_PREFIX)/lib/
	for so in libz.so libz.so.1 libz.so.*; do \
	  find $(SQLITE_STAGING)/lib -maxdepth 1 -name "$$so" -exec cp -P {} $(STAGING_INSTALL_PREFIX)/lib/ \; ; \
	done

.PHONY: syncthing_post_install
# cross/sqlite stages headers, pkgconfig data, manpages, etc.; prune those so
# the Syncthing SPK only ships the runtime `.so` files.
syncthing_post_install:
	@$(MSG) - Trim SQLite build artifacts
	@rm -f $(STAGING_INSTALL_PREFIX)/bin/sqlite3
	@rm -rf $(STAGING_INSTALL_PREFIX)/include $(STAGING_INSTALL_PREFIX)/share $(STAGING_INSTALL_PREFIX)/var
	@rm -rf $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
	@if [ -d $(STAGING_INSTALL_PREFIX)/lib ]; then \
	  find $(STAGING_INSTALL_PREFIX)/lib -maxdepth 1 -type f ! -name 'libsqlite3.so*' ! -name 'libz.so*' -delete; \
	  find $(STAGING_INSTALL_PREFIX)/lib -maxdepth 1 -type l ! -name 'libsqlite3.so*' ! -name 'libz.so*' -delete; \
	fi

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
# `cross/sqlite` is invoked as a dependency with INSTALL_DIR pointing at this
# package's work tree.  Depending on the caller (direct cross build vs. spk
# wrapper) the staged runtime lands in one of two locations; use whichever is
# present so CGO always locates headers and shared objects.
SQLITE_PREFIX_PRIMARY = $(WORK_DIR)/install/usr/local/syncthing
SQLITE_PREFIX_ALT = $(WORK_DIR)/install/var/packages/syncthing/target

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
	@if [ ! -d "$(SQLITE_PREFIX_PRIMARY)/lib" ] && [ ! -d "$(SQLITE_PREFIX_ALT)/lib" ]; then \
	  $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) --no-print-directory -C ../sqlite install >/dev/null; \
	fi
	@sqlite_prefix=$$( \
	  if [ -d "$(SQLITE_PREFIX_PRIMARY)/lib" ]; then \
	    echo "$(SQLITE_PREFIX_PRIMARY)"; \
	  elif [ -d "$(SQLITE_PREFIX_ALT)/lib" ]; then \
	    echo "$(SQLITE_PREFIX_ALT)"; \
	  fi ); \
	if [ -z "$$sqlite_prefix" ]; then \
	  echo "*** sqlite runtime missing after dependency build" >&2; \
	  exit 1; \
	fi; \
	cd $(GO_SRC_DIR) && env CGO_ENABLED=1 \
	  CGO_CFLAGS="-I$$sqlite_prefix/include" \
	  CGO_LDFLAGS="-L$$sqlite_prefix/lib -Wl,-rpath,\$$ORIGIN/../lib -Wl,--rpath-link,$$sqlite_prefix/lib -lsqlite3 -lz" \
	  PKG_CONFIG_PATH=$$sqlite_prefix/lib/pkgconfig \
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
	@sqlite_prefix=$$( \
	  if [ -d "$(SQLITE_PREFIX_PRIMARY)/lib" ]; then \
	    echo "$(SQLITE_PREFIX_PRIMARY)"; \
	  elif [ -d "$(SQLITE_PREFIX_ALT)/lib" ]; then \
	    echo "$(SQLITE_PREFIX_ALT)"; \
	  fi ); \
	if [ -z "$$sqlite_prefix" ]; then \
	  echo "*** sqlite runtime missing prior to install" >&2; \
	  exit 1; \
	fi; \
	if [ "$$sqlite_prefix" != "$(STAGING_INSTALL_PREFIX)" ]; then \
	  cp -a $$sqlite_prefix/lib/libsqlite3.so* $(STAGING_INSTALL_PREFIX)/lib/; \
	  for so in libz.so libz.so.1 libz.so.*; do \
	    find $$sqlite_prefix/lib -maxdepth 1 -name "$$so" -exec cp -P {} $(STAGING_INSTALL_PREFIX)/lib/ \; ; \
	  done; \
	fi

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

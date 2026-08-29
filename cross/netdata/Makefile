PKG_NAME = netdata
PKG_VERS = 2.11.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/netdata/netdata/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/curl cross/lz4 cross/zstd cross/libuuid cross/libuv cross/libyaml cross/procps-ng
BUILD_DEPENDS = native/protoc_33 cross/aclk-schemas native/go

HOMEPAGE = https://www.netdata.cloud
COMMENT  = Real-time performance monitoring, done right
LICENSE  = GPLv3

# netdata compiles C++17, which requires gcc 7.5 or newer (verified against the oldest
# DSM 7 toolchain); older toolchains cannot compile it.
MIN_GCC_VERSION = 7.5

ACLK_SCHEMAS_DIR = aclk-schemas-$(shell grep "^PKG_VERS " ../aclk-schemas/Makefile | sed 's/.*= //')

CONFIGURE_ARGS  = -DENABLE_PLUGIN_GO=ON
CONFIGURE_ARGS += -DENABLE_PLUGIN_PYTHON=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_APPS=ON
CONFIGURE_ARGS += -DENABLE_ML=OFF
CONFIGURE_ARGS += -DENABLE_DASHBOARD=ON
CONFIGURE_ARGS += -DENABLE_DBENGINE=ON

# Features disabled to avoid cross-compilation issues
CONFIGURE_ARGS += -DENABLE_PLUGIN_SCRIPTS=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_OTEL=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_OTEL_SIGNAL_VIEWER=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_CUPS=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_FREEIPMI=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_EBPF=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_SYSTEMD_UNITS=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_XENSTAT=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_NFACCT=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_LOCAL_LISTENERS=ON
CONFIGURE_ARGS += -DENABLE_PLUGIN_NETWORK_VIEWER=ON
CONFIGURE_ARGS += -DENABLE_PLUGIN_DEBUGFS=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_PERF=OFF
CONFIGURE_ARGS += -DENABLE_PLUGIN_SLABINFO=OFF
CONFIGURE_ARGS += -DENABLE_EXPORTER_PROMETHEUS_REMOTE_WRITE=OFF
CONFIGURE_ARGS += -DENABLE_LIBBACKTRACE=OFF
CONFIGURE_ARGS += -DENABLE_BUNDLED_PROTOBUF=ON
# systemd journal log browsing, using netdata's own journal file reader
# (the Rust journal_reader_ffi static library, see netdata_compile below)
CONFIGURE_ARGS += -DENABLE_PLUGIN_SYSTEMD_JOURNAL=ON
CONFIGURE_ARGS += -DENABLE_NETDATA_JOURNAL_FILE_READER=ON

POST_PATCH_TARGET = netdata_post_patch
COMPILE_TARGET = netdata_compile

include ../../mk/spksrc.cross-cmake.mk
# RUST_TARGET / TC_RUSTUP_TOOLCHAIN for cross-compiling the journal reader crate.
# Not provided by the generated tc_vars.mk, so included explicitly.
include ../../mk/spksrc.cross/env-rust.mk
# GOOS/GOARCH/GOARM + CGO_ENABLED=0 + native/go PATH for the go.d plugin build.
include ../../mk/spksrc.cross/env-go.mk

.PHONY: netdata_post_patch
netdata_post_patch:
	@$(MSG) Patching CMakeLists.txt for writable paths
	cd $(WORK_DIR)/$(PKG_DIR) && sed \
		-e 's?set(CACHE_DIR "$${NETDATA_RUNTIME_PREFIX}/var/cache/netdata")?set(CACHE_DIR "$(INSTALL_PREFIX_VAR)/cache/netdata")?' \
		-e 's?set(CONFIG_DIR "$${NETDATA_RUNTIME_PREFIX}/etc/netdata")?set(CONFIG_DIR "$(INSTALL_PREFIX_VAR)/etc/netdata")?' \
		-e 's?set(LOG_DIR "$${NETDATA_RUNTIME_PREFIX}/var/log/netdata")?set(LOG_DIR "$(INSTALL_PREFIX_VAR)/log/netdata")?' \
		-e 's?set(VARLIB_DIR "$${NETDATA_RUNTIME_PREFIX}/var/lib/netdata")?set(VARLIB_DIR "$(INSTALL_PREFIX_VAR)/lib/netdata")?' \
		-i.bak CMakeLists.txt
	@$(MSG) Patching SNMP trap profile pack to build for the build host
	@cd $(WORK_DIR)/$(PKG_DIR) && perl -i -0pe 's/(GOROOT=\$$\{GO_ROOT\})(\s+CGO_ENABLED=0\s+GOPROXY=https:\/\/proxy\.golang\.org,direct\s+"\$$\{GO_EXECUTABLE\}" run [^\n]*snmptrapprofilegen compress-zstd)/$$1 GOOS=linux GOARCH=amd64$$2/' CMakeLists.txt

.PHONY: netdata_compile
netdata_compile:
	@$(MSG) Installing aclk-schemas proto files
	@ACLK_DIR=$(WORK_DIR)/$(PKG_DIR)/src/aclk/aclk-schemas; \
	mkdir -p $$ACLK_DIR/proto && \
	if [ ! -f "$$ACLK_DIR/proto/aclk/v1/lib.proto" ]; then \
		cp -a $(WORK_DIR)/$(ACLK_SCHEMAS_DIR)/proto/. $$ACLK_DIR/proto/; \
	fi
	@$(MSG) Patching protobuf rules for native protoc
	@PROTOC=$$(realpath $(WORK_DIR)/../../../native/protoc_33/work-native/bin/protoc 2>/dev/null); \
	NINJA=$(BUILD_DIR)/build.ninja; \
	if [ -n "$$PROTOC" ] && [ -f "$$NINJA" ]; then \
		sed -i "s|protobuf::protoc|$$PROTOC|g" $$NINJA; \
		# netdata's cmake points --cpp_out at src/aclk/aclk-schemas/proto, but protoc \
		# then writes to .../proto/<pkg>/vN -- the ninja build rules expect the \
		# generated sources at src/aclk/aclk-schemas/<pkg>/vN, so normalize the \
		# output directory to the build tree's aclk-schemas dir. \
		sed -i '/protoc/s|--cpp_out=[^ ]*/src/aclk/aclk-schemas[^ ]*|--cpp_out=$(BUILD_DIR)/src/aclk/aclk-schemas|g' $$NINJA; \
	fi
	@$(MSG) Building the netdata journal reader
	@cd $(WORK_DIR)/$(PKG_DIR)/src/crates/jf && export PATH="$$HOME/.cargo/bin:$$PATH" && cargo +$(TC_RUSTUP_TOOLCHAIN) build --release --target $(RUST_TARGET) -p journal_reader_ffi
	@cp $(WORK_DIR)/$(PKG_DIR)/src/crates/jf/target/$(RUST_TARGET)/release/libjournal_reader_ffi.a $(WORK_DIR)/$(PKG_DIR)/
	$(RUN) cmake --build $(BUILD_DIR) -j $(NCPUS)

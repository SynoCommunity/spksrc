PKG_NAME = netdata
PKG_VERS = 2.10.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/netdata/netdata/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/curl cross/lz4 cross/zstd cross/libuuid cross/libuv cross/libyaml cross/procps-ng
BUILD_DEPENDS = native/protoc_33 cross/aclk-schemas

HOMEPAGE = https://www.netdata.cloud
COMMENT  = Real-time performance monitoring, done right
LICENSE  = GPLv3

ACLK_SCHEMAS_DIR = aclk-schemas-$(shell grep "^PKG_VERS " ../aclk-schemas/Makefile | sed 's/.*= //')

CMAKE_ARGS  = -DENABLE_PLUGIN_GO=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_PYTHON=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_APPS=ON
CMAKE_ARGS += -DENABLE_ML=OFF
CMAKE_ARGS += -DENABLE_DASHBOARD=ON
CMAKE_ARGS += -DENABLE_DBENGINE=ON

# Features disabled to avoid cross-compilation issues
CMAKE_ARGS += -DENABLE_PLUGIN_SCRIPTS=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_OTEL=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_OTEL_SIGNAL_VIEWER=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_CUPS=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_FREEIPMI=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_EBPF=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_SYSTEMD_JOURNAL=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_SYSTEMD_UNITS=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_XENSTAT=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_NFACCT=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_LOCAL_LISTENERS=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_NETWORK_VIEWER=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_DEBUGFS=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_PERF=OFF
CMAKE_ARGS += -DENABLE_PLUGIN_SLABINFO=OFF
CMAKE_ARGS += -DENABLE_EXPORTER_PROMETHEUS_REMOTE_WRITE=OFF
CMAKE_ARGS += -DENABLE_LIBBACKTRACE=OFF
CMAKE_ARGS += -DENABLE_BUNDLED_PROTOBUF=ON

POST_PATCH_TARGET = netdata_post_patch
COMPILE_TARGET = netdata_compile

include ../../mk/spksrc.cross-cmake.mk

.PHONY: netdata_post_patch
netdata_post_patch:
	@$(MSG) Patching CMakeLists.txt for writable paths
	cd $(WORK_DIR)/$(PKG_DIR) && sed \
		-e 's?set(CACHE_DIR "$${NETDATA_RUNTIME_PREFIX}/var/cache/netdata")?set(CACHE_DIR "$(INSTALL_PREFIX_VAR)/cache/netdata")?' \
		-e 's?set(CONFIG_DIR "$${NETDATA_RUNTIME_PREFIX}/etc/netdata")?set(CONFIG_DIR "$(INSTALL_PREFIX_VAR)/etc/netdata")?' \
		-e 's?set(LOG_DIR "$${NETDATA_RUNTIME_PREFIX}/var/log/netdata")?set(LOG_DIR "$(INSTALL_PREFIX_VAR)/log/netdata")?' \
		-e 's?set(VARLIB_DIR "$${NETDATA_RUNTIME_PREFIX}/var/lib/netdata")?set(VARLIB_DIR "$(INSTALL_PREFIX_VAR)/lib/netdata")?' \
		-i.bak CMakeLists.txt

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
	NINJA=$(CMAKE_BUILD_DIR)/build.ninja; \
	if [ -n "$$PROTOC" ] && [ -f "$$NINJA" ]; then \
		sed -i "s|protobuf::protoc|$$PROTOC|g" $$NINJA; \
		sed -i '/protoc/s|-I\([^ ]*\)/src/aclk/aclk-schemas[[:space:]]|-I\1/src/aclk/aclk-schemas/proto |g' $$NINJA; \
		sed -i '/protoc/s|--cpp_out=\([^ ]*\)/src/aclk/aclk-schemas[[:space:]]|--cpp_out=\1/src/aclk/aclk-schemas/proto |g' $$NINJA; \
		sed -i '/INCLUDES.*src\/aclk\/aclk-schemas/s|\(-I[^ ]*src/aclk/aclk-schemas\)\([[:space:]]\)|\1\2\1/proto\2|g' $$NINJA; \
	fi
	$(RUN) cmake --build $(CMAKE_BUILD_DIR) -j $(NCPUS)

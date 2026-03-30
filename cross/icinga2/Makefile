PKG_NAME = icinga2
PKG_VERS = 2.15.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icinga2/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Icinga2 requires C++17 (GCC >= 7)
# DSM 7.1 provides GCC 12.x for most architectures
REQUIRED_MIN_DSM = 7.1
# comcerto2k has older toolchain than other DSM 7.1 archs
UNSUPPORTED_ARCHS = comcerto2k

BUILD_DEPENDS = native/icinga2-tools

DEPENDS  = cross/boost_1.86
DEPENDS += cross/openssl3

# Optional database backends for IDO
DEPENDS += cross/mariadb-connector-c
DEPENDS += cross/libpq

HOMEPAGE = https://icinga.com/
COMMENT  = Icinga 2 is an open source monitoring system that checks the availability of your network resources.
LICENSE  = GPLv2

# Boost configuration
BOOST_LIBRARIES = coroutine context date_time filesystem iostreams thread program_options regex system
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
# Set MYSQL_DIR for FindMySQL.cmake
ENV += MYSQL_DIR=$(STAGING_INSTALL_PREFIX)

# Icinga2-specific options
CMAKE_ARGS += -DICINGA2_WITH_MYSQL=ON
CMAKE_ARGS += -DICINGA2_WITH_PGSQL=ON
CMAKE_ARGS += -DICINGA2_WITH_CHECKER=ON
CMAKE_ARGS += -DICINGA2_WITH_NOTIFICATION=ON
CMAKE_ARGS += -DICINGA2_WITH_PERFDATA=ON
CMAKE_ARGS += -DICINGA2_WITH_ICINGADB=ON
CMAKE_ARGS += -DICINGA2_WITH_LIVESTATUS=ON
CMAKE_ARGS += -DICINGA2_WITH_COMPAT=ON
CMAKE_ARGS += -DICINGA2_WITH_TESTS=OFF
CMAKE_ARGS += -DUSE_SYSTEMD=OFF
CMAKE_ARGS += -DICINGA2_GIT_VERSION_INFO=OFF
CMAKE_ARGS += -DICINGA2_UNITY_BUILD=ON

# Boost paths
CMAKE_ARGS += -DBOOST_ROOT=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DBOOST_INCLUDEDIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DBOOST_LIBRARYDIR=$(STAGING_INSTALL_PREFIX)/lib
CMAKE_ARGS += -DBoost_NO_SYSTEM_PATHS=ON

# MySQL paths (using mariadb-connector-c with MySQL compatibility)
CMAKE_ARGS += -DMYSQL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/mariadb
# Set MYSQL_LIB cache variable directly (bypasses FIND_LIBRARY)
CMAKE_ARGS += -DMYSQL_LIB:FILEPATH=$(STAGING_INSTALL_PREFIX)/lib/libmysqlclient.so

# PostgreSQL paths
CMAKE_ARGS += -DPGSQL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DPGSQL_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib/libpq.so

# Disable editline/libedit - requires BSD libedit (histedit.h) not GNU readline
CMAKE_ARGS += -DICINGA2_WITH_EDITLINE=OFF

# OpenSSL paths
CMAKE_ARGS += -DOPENSSL_ROOT_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DOPENSSL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DOPENSSL_CRYPTO_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib/libcrypto.so
CMAKE_ARGS += -DOPENSSL_SSL_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib/libssl.so

# nlohmann json is bundled in third-party - set as cache var with PATH type
# to bypass FIND_PATH in cmake/FindJSON.cmake
CMAKE_ARGS += -DJSON_INCLUDE:PATH=$(WORK_DIR)/$(PKG_DIR)/third-party/nlohmann_json

# utf8cpp is bundled in third-party
CMAKE_ARGS += -DUTF8CPP_INCLUDE:PATH=$(WORK_DIR)/$(PKG_DIR)/third-party/utf8cpp/source

# Installation directories (will be customized in SPK)
CMAKE_ARGS += -DICINGA2_USER=icinga
CMAKE_ARGS += -DICINGA2_GROUP=icinga
CMAKE_ARGS += -DICINGA2_COMMAND_GROUP=icingacmd

# Skip user/group impersonation - handled by DSM service manager
ADDITIONAL_CXXFLAGS = -DICINGA2_SKIP_IMPERSONATION

# Native tools from native/icinga2-tools package
NATIVE_BUILD_DIR = $(realpath $(WORK_DIR)/../../../native/icinga2-tools/work-native/install/usr/local)

# Add native build tools to PATH during cross-compilation
ENV += PATH=$(NATIVE_BUILD_DIR)/bin:$$PATH

include ../../mk/spksrc.cross-cmake.mk

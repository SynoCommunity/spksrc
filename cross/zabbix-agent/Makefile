PKG_NAME = zabbix-agent
REAL_PKG_NAME = zabbix
PKG_VERS = 7.4.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(REAL_PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
SHORT_VERSION = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIST_SITE = https://cdn.zabbix.com/zabbix/sources/stable/$(SHORT_VERSION)
PKG_DIR = $(REAL_PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/zlib
DEPENDS += cross/openssl3
DEPENDS += cross/curl
DEPENDS += cross/pcre2

# build instructions:
# https://www.zabbix.com/documentation/current/en/manual/installation/install

# Notes on compilation options:
# 
# o Command-line utilities zabbix_get and zabbix_sender are compiled if --enable-agent option is used.
# o --with-libcurl and --with-libxml2 configuration options are required for virtual machine monitoring; 
#   --with-libcurl is also required for SMTP authentication and web.page.* Zabbix agent items. 
#   Note that cURL 7.20.0 or higher is required with the --with-libcurl configuration option.
# o Zabbix always compiles with the PCRE library; installing it is not optional. --with-libpcre=[DIR] only 
#   allows pointing to a specific base install directory, instead of searching through a number of common 
#   places for the libpcre files.
# o You may use the --enable-static flag to statically link libraries. If you plan to distribute compiled 
#   binaries among different servers, you must use this flag to make these binaries work without required 
#   libraries. Note that --enable-static does not work in Solaris.
# o Using --enable-static option is not recommended when building server. In order to build the server 
#   statically, you must have a static version of every external library needed. There is no strict check 
#   for that in configure script.
# o Add optional path to the MySQL configuration file --with-mysql=/<path_to_the_file>/mysql_config to select 
#   the desired MySQL client library when there is a need to use one that is not located in the default location. 
#   It is useful when there are several versions of MySQL installed or MariaDB installed alongside MySQL on the 
#   same system.


HOMEPAGE = https://www.zabbix.com
COMMENT  = Monitor anything - networks, cloud, websites, IoT, and more.
LICENSE  = AGPLv3

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-agent
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --enable-ipv6
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libpthread=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-openssl=$(STAGING_INSTALL_PREFIX)
# --with-libcurl must define curl-config and not the directory (ERROR: checking for the version of libcurl... ./configure: line 18672: .../install/usr/local/zabbix-agent: Is a directory)
CONFIGURE_ARGS += --with-libcurl=$(STAGING_INSTALL_PREFIX)/bin/curl-config
CONFIGURE_ARGS += --with-libpcre2=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

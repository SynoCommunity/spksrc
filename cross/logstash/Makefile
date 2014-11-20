PKG_NAME = logstash
PKG_VERS = 1.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.elasticsearch.org/logstash/logstash
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://logstash.net/
COMMENT  = "All your logs from all over your infrastructure in one place - with searching and graphing. logstash is a tool for managing events and logs. You can use it to collect logs, parse them, and store them for later use (like, for searching). Speaking of searching, logstash comes with a web interface for searching and drilling into all of your logs. It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way. logstash is now a part of the Elasticsearch family! This allows us to build better software much faster as well as offering production support.  NOTE: When starting logstash it might take a minute to a few minutes for it fully spin up, please be patient."
LICENSE  = Apache v2

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/logstash
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)-$(PKG_VERS) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/logstash
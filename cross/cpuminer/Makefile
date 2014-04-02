PKG_NAME = cpuminer
PKG_VERS = 2.3.3
PKG_EXT = zip
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pooler/cpuminer/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl cross/jansson

HOMEPAGE = http://www.transmissionbt.com/
COMMENT  = A Fast, Easy, and Free BitTorrent Client
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

CFLAGS = -03

PRE_CONFIGURE_TARGET = cpuMinerPreConfigure


include ../../mk/spksrc.cross-cc.mk

.PHONY: cpuMinerPreConfigure
cpuMinerPreConfigure:
	cd $(WORK_DIR)/$(PKG_DIR) && sh autogen.sh

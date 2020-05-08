PKG_NAME = rar2fs
PKG_VERS = 1.29.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/hasse69/rar2fs/releases/download/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

CONFIGURE_ARGS = --with-fuse=$(WORK_DIR)/libfuse-fuse-2.9.9/include --with-fuse-lib=$(WORK_DIR)/install/usr/local/rar2fs/lib --with-unrar=$(WORK_DIR)/unrar
BUILD_DEPENDS = cross/fuse cross/unrar
PRE_CONFIGURE_TARGET = staticrar
HOMEPAGE = https://github.com/hasse69/rar2fs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: staticrar
staticrar:
	export $(cat work-x86-6.1/tc_vars.mk | cut -d' ' -f3 | grep "[A-Z]\=\".*\"") && \
        cd $(WORK_DIR)/unrar && \
	echo "boooo $(CXX)" && \
	make -f makefile lib 

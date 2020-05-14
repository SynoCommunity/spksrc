PKG_NAME = rar2fs
PKG_VERS = 1.29.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
2PKG_DIST_SITE = https://github.com/hasse69/rar2fs/releases/download/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

CONFIGURE_ARGS = --with-fuse=$(WORK_DIR)/libfuse-fuse-2.9.9/include --with-fuse-lib=$(WORK_DIR)/install/usr/local/rar2fs/lib --with-unrar=$(WORK_DIR)/unrar
BUILD_DEPENDS = cross/fuse cross/unrar
PRE_CONFIGURE_TARGET = fulfill_rar2fs_prerequisite
PRE_COMPILE_TARGET = build_unrar_static
HOMEPAGE = https://github.com/hasse69/rar2fs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: fulfill_rar2fs_prerequisite
fulfill_rar2fs_prerequisite:
	touch $(WORK_DIR)/unrar/libunrar.a

.PHONY: build_unrar_static
build_unrar_static:
	cd $(WORK_DIR)/unrar; \
	make -f makefile lib;

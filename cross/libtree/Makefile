PKG_NAME = libtree
PKG_VERS = 3.1.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/haampie/libtree/archive

DEPENDS = 

HOMEPAGE = https://github.com/haampie/libtree
COMMENT  = A tool that turns ldd into a tree and explains how shared libraries are found or why they cannot be located
LICENSE  = MIT license

#UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

CONFIGURE_TARGET = nop
COMPILE_TARGET = libtree_compile_target
INSTALL_TARGET = libtree_install_target

ADDITIONAL_LDLAGS = -static

include ../../mk/spksrc.cross-cc.mk

.PHONY: libtree_compile_target
libtree_compile_target:
	$(RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS)

.PHONY: libtree_install_target
libtree_install_target:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/libtree $(STAGING_INSTALL_PREFIX)/bin

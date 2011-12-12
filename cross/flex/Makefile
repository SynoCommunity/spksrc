
PKG_NAME = flex
PKG_VERS = 2.5.35
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_DIR)

DEPENDS = 

MAINTAINER = http://packages.nas-forum.com
HOMEPAGE   = http://flex.sourceforge.net/
COMMENT    = Flex is a tool for generating scanners
LICENSE    = 

GNU_CONFIGURE = 1

CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
 
include ../../mk/spksrc.cross-cc.mk

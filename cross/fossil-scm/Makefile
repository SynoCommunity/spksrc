PKG_NAME = fossil-scm
PKG_VERS = 2.12.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.fossil-scm.org/index.html/tarball/version-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = https://www.fossil-scm.org/
COMMENT  = Fossil is a simple, high-reliability, distributed software configuration management system.
LICENSE  = 2-clause BSD

PRE_CONFIGURE_TARGET = fossil-scm_pre_configure

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --json 
CONFIGURE_ARGS += --disable-fusefs 
CONFIGURE_ARGS += --with-th1-docs --with-th1-hooks 
CONFIGURE_ARGS += --with-openssl=auto

include ../../mk/spksrc.cross-cc.mk

.PHONY: fossil-scm_pre_configure
fossil-scm_pre_configure:
	sed -i.orig -e "s|^BCCFLAGS.*$$|BCCFLAGS = |" $(WORK_DIR)/$(PKG_DIR)/Makefile.in

PKG_NAME = apr
PKG_VERS = 1.7.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://archive.apache.org/dist/apr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libuuid

HOMEPAGE = https://apr.apache.org
COMMENT  = The mission of the Apache Portable Runtime (APR) project is to create and maintain software libraries that provide a predictable and consistent interface to underlying platform-specific implementations.
LICENSE  = Apache 2.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-layout=GNU
CONFIGURE_ARGS += ac_cv_file__dev_zero=yes
CONFIGURE_ARGS += ac_cv_func_setpgrp_void=yes
CONFIGURE_ARGS += apr_cv_process_shared_works=no
CONFIGURE_ARGS += apr_cv_tcp_nodelay_with_cork=yes
CONFIGURE_ARGS += ac_cv_sizeof_struct_iovec=8

POST_INSTALL_TARGET = apr_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: apr_post_install
apr_post_install:
	sed -i -e 's|^prefix="$(INSTALL_PREFIX)"$$|prefix="$(STAGING_INSTALL_PREFIX)"|' $(STAGING_INSTALL_PREFIX)/bin/apr-1-config

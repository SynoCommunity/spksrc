PKG_NAME = apr
PKG_VERS = 1.5.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.apache.org/dist/apr/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://apr.apache.org/
COMMENT  = APR is the base portability library.
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-layout=GNU ac_cv_file__dev_zero=yes ac_cv_func_setpgrp_void=yes apr_cv_process_shared_works=no apr_cv_tcp_nodelay_with_cork=yes ac_cv_sizeof_struct_iovec=8

INSTALL_TARGET = noop

include ../../mk/spksrc.native-cc.mk


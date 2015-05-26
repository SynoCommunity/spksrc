PKG_NAME = apr
PKG_VERS = 1.5.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://apache.crihan.fr/dist/${PKG_NAME}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://apr.apache.org/
COMMENT  = APR is the base portability library.
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-layout=GNU ac_cv_file__dev_zero=yes ac_cv_func_setpgrp_void=yes apr_cv_process_shared_works=no apr_cv_tcp_nodelay_with_cork=yes ac_cv_sizeof_struct_iovec=8
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^prefix="$(INSTALL_PREFIX)"$$|prefix="$(STAGING_INSTALL_PREFIX)"|' $(STAGING_INSTALL_PREFIX)/bin/apr-1-config

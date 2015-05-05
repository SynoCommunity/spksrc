PKG_NAME = apr
PKG_VERS = 1.5.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.apache.org/dist/apr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://apr.apache.org/
COMMENT  = APR is the base portability library.
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-layout=GNU ac_cv_file__dev_zero=yes ac_cv_func_setpgrp_void=yes apr_cv_process_shared_works=no apr_cv_tcp_nodelay_with_cork=yes ac_cv_sizeof_struct_iovec=8
POST_INSTALL_TARGET = myPostInstall

HOSTGENTEST_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/tools/gen_test_char
HOSTGENTEST = $(WORK_DIR)/$(PKG_DIR)/tools/gen_test_char_native

# Compile
PRE_COMPILE_TARGET = myPreCompile

include ../../mk/spksrc.cross-cc.mk

myPreCompile:
	cp $(HOSTGENTEST_NATIVE) $(HOSTGENTEST)

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^prefix="$(INSTALL_PREFIX)"$$|prefix="$(STAGING_INSTALL_PREFIX)"|' $(STAGING_INSTALL_PREFIX)/bin/apr-1-config

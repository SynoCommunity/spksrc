PKG_NAME = ejabberd
PKG_VERS = 23.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/processone/ejabberd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/erlang
DEPENDS = cross/ncursesw cross/erlang cross/libexpat cross/zlib cross/openssl3 cross/libyaml

# PPC archs except qoriq have compiler errors with 64 bit values
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.ejabberd.im
COMMENT  = Robust, Scalable and Extensible Realtime Platform XMPP Server + MQTT Broker + SIP Service.
LICENSE  = GPLv2

NATIVE_ERLANG_ROOT_DIR = $(abspath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local)
NATIVE_ERLANG_BIN = $(NATIVE_ERLANG_ROOT_DIR)/bin

GNU_CONFIGURE = 1
# force native erlang root dir
CONFIGURE_ARGS = ac_cv_erlang_root_dir=$(NATIVE_ERLANG_ROOT_DIR)
CONFIGURE_ARGS += --enable-mysql

# for 'rebar configure-deps' + 'rebar compile' to find cross compiled libei.a and liberl_interface.a
# remarks: arguments for rebar are collected in 'vars.config'
ADDITIONAL_LDFLAGS = -L$(STAGING_INSTALL_PREFIX)/lib/erlang/usr/lib
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/lib/erlang/usr/include
ADDITIONAL_CPPFLAGS = $(ADDITIONAL_CFLAGS)

PRE_CONFIGURE_TARGET = ejabberd_pre_configure
POST_INSTALL_TARGET = ejabberd_post_install

# let configure find the host erlang executables
ENV += PATH=$(NATIVE_ERLANG_BIN):$$PATH

include ../../mk/spksrc.cross-cc.mk

.PHONY: ejabberd_pre_configure
# patch rebar.config.script for 'rebar configure-deps' to add --host and --build
# related to: https://github.com/processone/ejabberd/issues/139
ejabberd_pre_configure:
	@$(MSG) Patch to fix cross compile of rebar package
	@$(RUN) ; sed -e "s#\" ./configure \"#\" ./configure $(TC_CONFIGURE_ARGS)\"#g" -i ./rebar.config.script
	@$(MSG) Run autogen and avoid to take version from git tag
	@$(RUN) ; sed 's?git describe --tags 2>/dev/null || ??' -i ./configure.ac
	@$(RUN) ; ./autogen.sh

.PHONY: ejabberd_post_install
# patch the generated ejabberdctl script
# and link sbin/ejabberdctl into bin (as DSM7 does not support executables in sbin folders).
ejabberd_post_install:
	sed -e "s#$(INSTALL_DIR)##g" 										\
		 -e "s#$(NATIVE_ERLANG_BIN)#$(INSTALL_PREFIX)/bin#g"	\
		 -e "s#^INSTALLUSER=.*#INSTALLUSER=\"sc-ejabberd\"#g"	\
		 -e "s#/etc/ejabberd\"#/var\"#g"								\
		 -e "s#/var/lib/ejabberd\"#/var/lib\"#g"					\
		 -e "s#/var/log/ejabberd\"#/var/log\"#g"					\
		 -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ../sbin/ejabberdctl .

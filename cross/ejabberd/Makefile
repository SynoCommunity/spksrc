PKG_NAME = ejabberd
PKG_VERS = 21.01
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://static.process-one.net/ejabberd/downloads/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/erlang 
DEPENDS = cross/ncurses cross/erlang cross/expat cross/zlib cross/openssl cross/libyaml

# PPC archs except qoriq have compiler errors with 64 bit values
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.ejabberd.im
COMMENT  = Robust, Scalable and Extensible Realtime Platform XMPP Server + MQTT Broker + SIP Service.
LICENSE  = GPLv2

NATIVE_ERLANG_ROOT_DIR = $(realpath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local)
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
# fix cross compile of dependent packages
# patch rebar.config.script for 'rebar configure-deps' to add --host and --build
# related to: https://github.com/processone/ejabberd/issues/139
ejabberd_pre_configure:
	sed -e "s#\" ./configure \"#\" ./configure $(TC_CONFIGURE_ARGS)\"#g" -i $(WORK_DIR)/$(PKG_DIR)/rebar.config.script

.PHONY: ejabberd_post_install
# patch the generated ejabberdctl script
# and link bin/ejabberdctl (DSM7 does not support executables in sbin folders).
ejabberd_post_install:
	sed -e "s#$(INSTALL_DIR)##g" 										\
		 -e "s#$(NATIVE_ERLANG_BIN)#$(INSTALL_PREFIX)/bin#g"	\
		 -e "s#^INSTALLUSER=.*#INSTALLUSER=\"sc-ejabberd\"#g"	\
		 -e "s#/etc/ejabberd\"#/var\"#g"								\
		 -e "s#/var/lib/ejabberd\"#/var/lib\"#g"					\
		 -e "s#/var/log/ejabberd\"#/var/log\"#g"					\
		 -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	cd $(STAGING_INSTALL_PREFIX)/bin && ln -s ../sbin/ejabberdctl .

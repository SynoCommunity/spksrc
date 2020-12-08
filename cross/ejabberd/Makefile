PKG_NAME = ejabberd
PKG_VERS = 2.1.13
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.process-one.net/downloads/ejabberd/$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/src

DEPENDS = cross/expat cross/zlib cross/openssl native/erlang

HOMEPAGE = https://www.ejabberd.im
COMMENT  = ejabberd is high-performace enterprise Jabber/XMPP instant messaging server written in Erlang/OTP. It's cross-platform, fault-tolerant, clusterable and modular.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --with-erlang=$(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin

PRE_CONFIGURE_TARGET = ejabberd_pre_configure
POST_INSTALL_TARGET = ejabberd_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: ejabberd_pre_configure
ejabberd_pre_configure:
	@$(RUN) sed -e "s#-I\$$ERLANG_EI_DIR#-I$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/erlang/lib/erl_interface-3.7.15#g" -i configure
	@$(RUN) sed -e "s#-L\$$ERLANG_EI_LIB#-L$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/erlang/lib/erl_interface-3.7.15/lib#g" -i configure

.PHONY: ejabberd_post_install
ejabberd_post_install:
	sed -e "s#$(INSTALL_DIR)##g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s#^INSTALLUSER=#INSTALLUSER=ejabberd#g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s#ERL=$(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin/erl#ERL=$(INSTALL_PREFIX)/bin/erl#g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s#! -x \"\$$FLOCK\"#\"1\"#g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s|^#EJABBERD_PID_PATH=/var/run/ejabberd/ejabberd.pid|EJABBERD_PID_PATH=/usr/local/ejabberd/var/ejabberd.pid|g" -i $(STAGING_INSTALL_PREFIX)/etc/ejabberd/ejabberdctl.cfg

PKG_NAME = ejabberd
PKG_VERS = 2.1.13
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.process-one.net/downloads/ejabberd/$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/src

DEPENDS = cross/expat cross/zlib cross/openssl native/erlang

HOMEPAGE = http://www.ejabberd.im
COMMENT  = ejabberd is high-performace enterprise Jabber/XMPP instant messaging server written in Erlang/OTP. It's cross-platform, fault-tolerant, clusterable and modular.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --with-erlang=$(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin

PRE_CONFIGURE_TARGET = myPreConfigure
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	@$(RUN) sed -e "s#-I\$$ERLANG_EI_DIR#-I$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/erlang/lib/erl_interface-3.7.7#g" -i configure
	@$(RUN) sed -e "s#-L\$$ERLANG_EI_LIB#-L$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/erlang/lib/erl_interface-3.7.7/lib#g" -i configure

.PHONY: myPostInstall
myPostInstall:
	sed -e "s#$(INSTALL_DIR)##g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s#^INSTALLUSER=#INSTALLUSER=ejabberd#g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s#ERL=$(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin/erl#ERL=$(INSTALL_PREFIX)/bin/erl#g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s#! -x \"\$$FLOCK\"#\"1\"#g" -i $(STAGING_INSTALL_PREFIX)/sbin/ejabberdctl
	sed -e "s|^#EJABBERD_PID_PATH=/var/run/ejabberd/ejabberd.pid|EJABBERD_PID_PATH=/usr/local/ejabberd/var/ejabberd.pid|g" -i $(STAGING_INSTALL_PREFIX)/etc/ejabberd/ejabberdctl.cfg

PKG_NAME = erlang
PKG_VERS = R16B03-1
PKG_EXT = tar.gz
PKG_DIST_NAME = otp_src_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.erlang.org/download/
PKG_DIR = otp_src_$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Erlang Public License

GNU_CONFIGURE = 1

INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.native-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install INSTALL_PREFIX=$(INSTALL_DIR)

.PHONY: myPostInstall
myPostInstall:
	sed -i 's#ROOTDIR="/usr/local/lib/erlang"#ROOTDIR="$(INSTALL_DIR)/usr/local/lib/erlang"#' $(INSTALL_DIR)/usr/local/bin/erl

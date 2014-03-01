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

CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

include ../../mk/spksrc.native-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./configure --prefix=$(INSTALL_DIR)$(INSTALL_PREFIX)

.PHONY: myInstall
myInstall:
	$(RUN) make install INSTALL_PREFIX=

PKG_NAME = erlang
PKG_VERS = R16B03-1
PKG_EXT = tar.gz
PKG_DIST_NAME = otp_src_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://erlang.org/download/
PKG_DIR = otp_src_$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Erlang Public License

CONFIGURE_TARGET = erlang_configure
INSTALL_TARGET = erlang_install

include ../../mk/spksrc.native-cc.mk

.PHONY: erlang_configure
erlang_configure:
	$(RUN) ./configure --prefix=$(INSTALL_DIR)$(INSTALL_PREFIX)

.PHONY: erlang_install
erlang_install:
	$(RUN) make install INSTALL_PREFIX=

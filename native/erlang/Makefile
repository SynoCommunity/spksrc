PKG_NAME = erlang
PKG_VERS = 23.2
PKG_EXT = tar.gz
PKG_DIST_NAME = otp_src_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.erlang.org/download/
PKG_DIR = otp_src_$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Apache 2.0

PRE_CONFIGURE_TARGET = erlang_pre_configure
CONFIGURE_TARGET = erlang_configure
INSTALL_TARGET = erlang_install

CONFIGURE_ARGS  = --without-javac
CONFIGURE_ARGS += --without-jinterface
CONFIGURE_ARGS += --without-odbc
CONFIGURE_ARGS += --enable-dynamic-ssl-lib
CONFIGURE_ARGS += --prefix=$(INSTALL_DIR)$(INSTALL_PREFIX)
CONFIGURE_ARGS += CFLAGS="-O2 -g -D_GNU_SOURCE"

include ../../mk/spksrc.native-cc.mk

.PHONY: erlang_pre_configure
erlang_pre_configure:
	$(RUN) ./otp_build autoconf

.PHONY: erlang_configure
erlang_configure:
	$(RUN) ./otp_build configure $(CONFIGURE_ARGS)


.PHONY: erlang_install
erlang_install:
	$(RUN) make install INSTALL_PREFIX=

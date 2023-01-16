PKG_NAME = erlang
PKG_VERS = 24.1
PKG_EXT = tar.gz
PKG_DIST_NAME = OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erlang/otp/archive
PKG_DIST_FILE = $(PKG_NAME)-OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = otp-OTP-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Apache 2.0

CONFIGURE_TARGET = erlang_configure
INSTALL_MAKE_OPTIONS = install INSTALL_PREFIX=

CONFIGURE_ARGS  = --without-javac
CONFIGURE_ARGS += --without-jinterface
CONFIGURE_ARGS += --without-odbc
CONFIGURE_ARGS += --enable-dynamic-ssl-lib
CONFIGURE_ARGS += --prefix=$(INSTALL_DIR)$(INSTALL_PREFIX)
CONFIGURE_ARGS += CFLAGS="-O2 -g -D_GNU_SOURCE"

include ../../mk/spksrc.native-cc.mk

.PHONY: erlang_configure
erlang_configure:
	$(RUN) ./otp_build configure $(CONFIGURE_ARGS)


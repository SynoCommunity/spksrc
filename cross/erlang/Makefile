PKG_NAME = erlang
PKG_VERS = 23.3.4.1
PKG_EXT = tar.gz
PKG_DIST_NAME = OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erlang/otp/archive
PKG_DIST_FILE = $(PKG_NAME)-OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = otp-OTP-$(PKG_VERS)

BUILD_DEPENDS = native/$(PKG_NAME)
DEPENDS = cross/ncurses cross/openssl

HOMEPAGE = https://www.erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Apache 2.0

NATIVE_ERLANG_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin)
ENV = PATH=$$PATH:$(NATIVE_ERLANG_BIN_DIR)

GNU_CONFIGURE = 1

INSTALL_TARGET = erlang_install

CONFIGURE_ARGS  = --without-javac
CONFIGURE_ARGS += --without-jinterface
CONFIGURE_ARGS += --without-odbc
CONFIGURE_ARGS += --without-wx
CONFIGURE_ARGS += --enable-dynamic-ssl-lib 
CONFIGURE_ARGS += --with-ssl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += erl_xcomp_sysroot=$(INSTALL_DIR)
CONFIGURE_ARGS += CFLAGS="-O2 -g -D_GNU_SOURCE"

include ../../mk/spksrc.cross-cc.mk

.PHONY: erlang_install
erlang_install:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) INSTALL_PREFIX=

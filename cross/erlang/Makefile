PKG_NAME = erlang
PKG_VERS = 22.3.4.13
PKG_EXT = tar.gz
PKG_DIST_NAME = OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.erlang.org/download/
PKG_DIST_FILE = $(PKG_NAME)-OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = otp-OTP-$(PKG_VERS)

DEPENDS = native/$(PKG_NAME) cross/ncurses cross/openssl

HOMEPAGE = https://www.erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Apache 2.0

NATIVE_ERLANG_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin)
ENV = PATH=$$PATH:$(NATIVE_ERLANG_BIN_DIR)

# for archs definitions
include ../../mk/spksrc.archs.mk

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = erlang_pre_configure
INSTALL_TARGET = erlang_install

CONFIGURE_ARGS = --without-javac
CONFIGURE_ARGS += --without-jinterface
CONFIGURE_ARGS += --without-odbc
CONFIGURE_ARGS += --enable-dynamic-ssl-lib 
CONFIGURE_ARGS += --with-ssl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += erl_xcomp_sysroot=$(INSTALL_DIR)

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-smp-require-native-atomics
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: erlang_pre_configure
erlang_pre_configure:
	$(RUN) ./otp_build autoconf

include ../../mk/spksrc.cross-cc.mk

.PHONY: erlang_pre_configure
erlang_pre_configure:
	$(RUN) ./otp_build autoconf

.PHONY: erlang_install
erlang_install:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) INSTALL_PREFIX=

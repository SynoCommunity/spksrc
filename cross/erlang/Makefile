PKG_NAME = erlang
PKG_VERS = 24.1
PKG_EXT = tar.gz
PKG_DIST_NAME = OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erlang/otp/archive
PKG_DIST_FILE = $(PKG_NAME)-OTP-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = otp-OTP-$(PKG_VERS)

BUILD_DEPENDS = native/$(PKG_NAME)
DEPENDS = cross/ncursesw cross/openssl

HOMEPAGE = https://www.erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Apache 2.0

NATIVE_ERLANG_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/erlang/work-native/install/usr/local/bin)
ENV = PATH=$$PATH:$(NATIVE_ERLANG_BIN_DIR)

INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) INSTALL_PREFIX=

CONFIGURE_ARGS  = --without-javac
CONFIGURE_ARGS += --without-jinterface
CONFIGURE_ARGS += --without-odbc
CONFIGURE_ARGS += --without-wx
CONFIGURE_ARGS += --enable-dynamic-ssl-lib 
CONFIGURE_ARGS += --with-ssl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += erl_xcomp_sysroot=$(INSTALL_DIR)
CONFIGURE_ARGS += CFLAGS="-O2 -g -D_GNU_SOURCE"

include ../../mk/spksrc.archs.mk
# custom definition of args normally defined with GNU_CONFIGURE = 1, to force cross compilation (see below)
CONFIGURE_ARGS += --host=$(TC_TARGET) --prefix=$(INSTALL_PREFIX)

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
# force cross compilation for i686 to avoid the following error:
# We are cross compiling since the '--host=i686-pc-linux-gnu' and the '--build=i686-pc-linux' arguments differ.
# When cross compiling Erlang/OTP also the canonicalized values of the '--build' and the '--host' arguments *must* differ.
# The canonicalized values of these arguments however both equals: i686-pc-linux-gnu
CONFIGURE_ARGS += --build=x86_64-pc-linux
else
CONFIGURE_ARGS += --build=i686-pc-linux
endif

include ../../mk/spksrc.cross-cc.mk

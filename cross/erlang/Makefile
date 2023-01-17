PKG_NAME = erlang
PKG_VERS = R16B03-1
PKG_EXT = tar.gz
PKG_DIST_NAME = otp_src_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.erlang.org/download/
PKG_DIR = otp_src_$(PKG_VERS)

DEPENDS = native/$(PKG_NAME) cross/ncurses cross/openssl

HOMEPAGE = http://www.erlang.org
COMMENT  = Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.
LICENSE  = Erlang Public License

# Get arch-defs now
include ../../mk/spksrc.cross-cc.mk

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --with-ssl=$(STAGING_INSTALL_PREFIX) erl_xcomp_sysroot=$(INSTALL_DIR)
ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-smp-require-native-atomics
endif

INSTALL_TARGET = myInstall

ENV += PATH=$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin:$$PATH

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) INSTALL_PREFIX=

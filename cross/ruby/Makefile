PKG_NAME = ruby
PKG_VERS = 4.0.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://cache.ruby-lang.org/pub/ruby/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/ruby
DEPENDS = cross/openssl3 cross/libffi cross/libyaml

# glibc 2.8 has no epoll_create1 (added in 2.9):
#   thread_pthread_mn.c:874: 'EPOLL_CLOEXEC' undeclared
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = http://www.ruby-lang.org/
COMMENT  = Ruby Programming Language.
LICENSE  = 2-clause BSDL

NATIVE_RUBY = $(realpath $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/ruby)

# Configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-baseruby=$(NATIVE_RUBY) --prefix=$(INSTALL_PREFIX) --disable-install-doc
include ../../mk/spksrc.common.mk
# aarch64-6.2.4's binutils 2.25 cannot link the YJIT Rust objects
# (R_AARCH64_LD64_GOT_LO12_NC); the 7.x toolchain (binutils 2.30) can
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
ifeq ($(call version_ge,$(TC_BINUTILS),2.30),1)
CONFIGURE_ARGS += --enable-yjit
endif
endif

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk


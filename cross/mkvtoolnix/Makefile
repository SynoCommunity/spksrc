PKG_NAME = mkvtoolnix
PKG_VERS = 58.0.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mkvtoolnix.download/sources
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

REQUIRED_MIN_DSM = 7.1
# mkvtoolnix > 22.x require C++14 (DSM 7 only)
# no further updates possible:
# mkvtoolnix > 46.x need some features of C++17
# mkvtoolnix > 53.x need features file system library (C++17) not supported on DSM 7.0
# mkvtoolnix > 58.x need features gcc >= 10.x not supported on DSM 7.1
# Breaking changes with mkvtoolnix >= 59.0
#  The Qt library is now required for building all applications, even the
#  command-line ones, as they use Qt's MIME type detection capabilities

# comcerto2k has older toolchain than other DSM 7.1 archs
UNSUPPORTED_ARCHS = comcerto2k

BUILD_DEPENDS = native/ruby
# build cross/libicu before cross/boost to build libboost_regex with unicode support
DEPENDS = cross/libicu cross/boost
DEPENDS += cross/libogg cross/libvorbis cross/zlib
DEPENDS += cross/flac cross/file
DEPENDS += cross/libebml cross/libmatroska
DEPENDS += cross/pcre2

HOMEPAGE = https://mkvtoolnix.download/index.html
COMMENT  = MKVToolNix is a set of tools to create, alter and inspect Matroska files.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
COMPILE_TARGET = mkvtoolnix_compile
INSTALL_TARGET = mkvtoolnix_install

CONFIGURE_ARGS = --prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-boost-libdir=$(STAGING_INSTALL_PREFIX)/lib

BOOST_LIBRARIES = regex date_time
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

NATIVE_RUBY_DIR = $(realpath $(WORK_DIR)/../../../native/ruby/work-native/install/usr/local/bin)
ENV += PATH=$(NATIVE_RUBY_DIR):$$PATH

ADDITIONAL_CXXFLAGS += -Os

include ../../mk/spksrc.cross-cc.mk

.PHONY: mkvtoolnix_compile
mkvtoolnix_compile:
	$(RUN) rake

.PHONY: mkvtoolnix_install
mkvtoolnix_install:
	$(RUN) rake install

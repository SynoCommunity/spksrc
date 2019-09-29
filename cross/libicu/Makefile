PKG_NAME = icu
PKG_VERS = 64.2
PKG_EXT = tgz
PKG_DIST_NAME = icu4c-64_2-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-64-2/
PKG_DIR = icu/source

DEPENDS = 

HOMEPAGE = http://icu-project.org/
COMMENT  = ICU is a mature, widely used set of C/C++ libraries providing Unicode and Globalization support for software applications.
LICENSE  = GPLv2

GNU_CONFIGURE =

CONFIGURE_ARGS = --disable-tests --disable-samples --disable-extras

include ../../mk/spksrc.cross-cc.mk


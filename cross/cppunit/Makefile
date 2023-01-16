PKG_NAME = cppunit
PKG_VERS = 1.15.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dev-www.libreoffice.org/src/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.freedesktop.org/wiki/Software/cppunit/
COMMENT  = CppUnit is the C++ port of the famous JUnit framework for unit testing. 
LICENSE  =

GNU_CONFIGURE = 1

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
ADDITIONAL_CPPFLAGS = -D_GLIBCXX_USE_C99_MATH -D_GLIBCXX_HAVE_OBSOLETE_ISNAN -D_GLIBCXX_HAVE_OBSOLETE_ISINF
ADDITIONAL_CXXFLAGS = $(ADDITIONAL_CPPFLAGS)
endif

include ../../mk/spksrc.cross-cc.mk

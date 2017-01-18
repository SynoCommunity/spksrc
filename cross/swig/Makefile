PKG_NAME = swig
PKG_VERS = 3.0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/swig/files/swig/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.swig.org/
COMMENT  = SWIG is an interface compiler that connects programs written in C and C++ with scripting languages such as Perl, Python, Ruby, and Tcl.
LICENSE  = GNU GPLv2
CONFIGURE_ARGS = --without-pcre
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk


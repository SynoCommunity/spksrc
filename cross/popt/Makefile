PKG_NAME = popt
PKG_VERS = 1.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.rpm.org/popt/releases/popt-1.x
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.linuxfromscratch.org/blfs/view/svn/general/popt.html
COMMENT  = The popt package contains the popt libraries which are used by some programs to parse command-line options.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

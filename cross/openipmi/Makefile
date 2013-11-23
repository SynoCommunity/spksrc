PKG_NAME = openipmi
PKG_VERS = 2.0.18
PKG_EXT = tar.gz
PKG_DIST_NAME = OpenIPMI-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/OpenIPMI%202.0%20Library/$(PKG_VERS)
PKG_DIR = OpenIPMI-$(PKG_VERS)

DEPENDS = cross/popt cross/ncurses cross/openssl

HOMEPAGE = http://openipmi.sourceforge.net/
COMMENT  = OpenIPMI is an effort to create a full-function IPMI system to allow full access to all IPMI information on a server and to abstract it to a level that will make it easy to use.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-openssl=yes

include ../../mk/spksrc.cross-cc.mk


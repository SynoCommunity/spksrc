PKG_NAME = rrdtool
PKG_VERS = 1.4.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://oss.oetiker.ch/rrdtool/pub
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/glib

HOMEPAGE = http://labs.bittorrent.com/experiments/sync.html
COMMENT  = Automatically sync files via secure, distributed technology
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-rrd_graph --disable-libdbi --disable-libwrap --disable-rrdcgi --disable-libtool-lock --disable-nls --disable-rpath --disable-perl --disable-ruby --disable-lua --disable-tcl --disable-python --disable-dependency-tracking XML2_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/xml2-config

include ../../mk/spksrc.cross-cc.mk



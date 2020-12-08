PKG_NAME = rrdtool
PKG_VERS = 1.7.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/oetiker/$(PKG_NAME)-1.x/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-1.x-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/glib cross/pango cross/groff cross/lua

HOMEPAGE = https://www.rrdtool.org
COMMENT  = RRDtool 1.x - Round Robin Database
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-docs --disable-rrd_graph --disable-libdbi --disable-libwrap --disable-rrdcgi
CONFIGURE_ARGS += --disable-nls --disable-rpath --disable-perl --disable-ruby
CONFIGURE_ARGS += --disable-tcl --disable-python --disable-dependency-tracking
CONFIGURE_ARGS += XML2_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/xml2-config
ADDITIONAL_CFLAGS = -DENABLE_NLS=0

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-cc.mk

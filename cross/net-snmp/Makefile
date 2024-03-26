PKG_NAME = net-snmp
PKG_VERS = 5.9.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/net-snmp/files/net-snmp/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = http://www.net-snmp.org/
COMMENT  = Net-SNMP is a suite of applications used to implement SNMP v1, SNMP v2c and SNMP v3 using both IPv4 and IPv6.
LICENSE  = BSD and CMU/UCD (BSD like)

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
# disable all features except "applications"
CONFIGURE_ARGS += --disable-agent
CONFIGURE_ARGS += --disable-manuals
CONFIGURE_ARGS += --disable-scripts
# required config options:
CONFIGURE_ARGS += --with-default-snmp-version="3"
CONFIGURE_ARGS += --without-logfile
CONFIGURE_ARGS += --without-persistent-directory
CONFIGURE_ARGS += --without-sys-contact
CONFIGURE_ARGS += --without-sys-location
# disable perl support:
CONFIGURE_ARGS += --disable-embedded-perl
CONFIGURE_ARGS += --without-perl-modules

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

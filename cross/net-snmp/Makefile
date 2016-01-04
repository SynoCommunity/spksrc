PKG_NAME = net-snmp
PKG_VERS = 5.7.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/net-snmp/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.net-snmp.org/
COMMENT  = Simple Network Management Protocol (SNMP) is a widely used protocol for monitoring the health and welfare of network equipment (eg. routers), computer equipment and even devices like UPSs. Net-SNMP is a suite of applications used to implement SNMP v1, SNMP v2c and SNMP v3 using both IPv4 and IPv6.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-default-snmp-version="1" --with-sys-contact="admin" --with-sys-location="Synology" 
CONFIGURE_ARGS += --with-logfile="none" --with-persistent-directory="/usr/local/var/net-snmp" 
CONFIGURE_ARGS += --disable-embedded-perl --disable-perl-cc-checks --without-perl-modules
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

PKG_NAME = net-snmp
PKG_VERS = 5.7.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =  

HOMEPAGE = http://www.net-snmp.org/
COMMENT  = Simple Network Management Protocol (SNMP) is a widely used protocol for monitoring the health and welfare of network equipment (eg. routers), computer equipment and even devices like UPSs.
LICENSE  =

   
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
 
include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure: 
	$(RUN) ./configure $(TC_CONFIGURE_ARGS) --prefix=$(INSTALL_DIR)$(INSTALL_PREFIX) --disable-manuals --disable-scripts --enable-mini-agent --without-rpm --enable-ipv6 --with-python-modules=no --with-perl-modules=no --enable-shared --disable-embedded-perl --with-mibdirs="/usr/syno/share/snmp/mibs" --with-default-snmp-version="3" --with-persistent-directory="/var/net-snmp" --with-logfile=/var/log/snmpd.log --with-sys-contact=root@localhost --with-sys-location=Unknown

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE)

.PHONY: myInstall
myInstall:
	$(RUN) make install INSTALL_PREFIX=

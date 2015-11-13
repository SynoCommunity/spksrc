PKG_NAME = libnet
PKG_VERS = 1.0.2a
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://packetfactory.openwall.net/libnet/dist/deprecated
PKG_DIR = Libnet-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://packetfactory.openwall.net/projects/libnet/
COMMENT  = Libnet is a high-level API (toolkit) allowing the application programmer to construct and inject network packets
LICENSE  = BSD

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure
POST_CONFIGURE_TARGET = myPostConfigure

include ../../mk/spksrc.cross-cc.mk

# see https://global.download.synology.com/download/Document/DeveloperGuide/DSM_Developer_Guide.pdf
#                            PowerPC MPC85xx PowerCUICC III
#                            |       |       PowerPC QorIQ
#                            |       |       |     ARM Armada.
#                            |       |       |     |         |---------.
#                            |       |       |     |         |         |
ifneq (,$(findstring $(ARCH),ppc853x ppc854x qoriq armada370 armada375 armadaxp))
  ENDIANNESS = B
else
  ENDIANNESS = L
endif

.PHONY: myPreConfigure myPostConfigure
myPreConfigure:
# manually define endianess:
# automatic detection of endianess fails, because `configure' cannot
# execute its test program (which is built for the cross-compiler
# target architecture and cannot run on the host machine as-is)
	sed -i $(WORK_DIR)/$(PKG_DIR)/configure -e "1953s|result=.*|result=$(ENDIANNESS)|"

myPostConfigure:
# LIBNET_CONFIG_CFLAGS is never set, also LIBNET_CONFIG_LIBS
# should contain the path to the libs but doesn't. Insert those
# paths here.
#
# Reference: OpenBSD Ports patch for configure.in
# http://www.openbsd.org/cgi-bin/cvsweb/ports/net/libnet/1.0/patches/patch-configure.in?rev=1.1;content-type=text%2Fplain
	sed -i -e "s|\(libnet_cflags=\"\)|\1-I$(INSTALL_DIR)/include|" $(WORK_DIR)/$(PKG_DIR)/libnet-config
	sed -i -e "s|\(libnet_libs=\"\)|\1-L$(INSTALL_DIR)/lib|" $(WORK_DIR)/$(PKG_DIR)/libnet-config

# man-files seem to go to the wrong place
	sed -i $(WORK_DIR)/$(PKG_DIR)/Makefile -e "20s|MAN_PREFIX  =.*|MAN_PREFIX  =   \$${prefix}/man/man3|"

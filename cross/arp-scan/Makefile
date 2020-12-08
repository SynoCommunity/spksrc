PKG_NAME = arp-scan
PKG_VERS = 1.9.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/royhills/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap

HOMEPAGE = https://www.royhills.co.uk/wiki/index.php/Arp-scan_User_Guide
COMMENT  = Command-line tool for system discovery and fingerprinting. It constructs and sends ARP requests to the specified IP addresses, and displays any responses that are received. 
LICENSE  = MIT

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = arp-scan_pre_configure

# use the standard C99 format (it cannot be determined due to cross compilation)
CONFIGURE_ARGS = pgac_cv_snprintf_long_long_int_format="%lld"
# needed for compilation to avoid warning "_FORTIFY_SOURCE requires compiling with optimization (-O)"
ADDITIONAL_CPPFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk

.PHONY: arp-scan_pre_configure
arp-scan_pre_configure:
	$(RUN) autoreconf --install

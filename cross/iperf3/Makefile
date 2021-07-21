PKG_NAME = iperf3
PKG_VERS = 3.10.1
PKG_EXT = tar.gz
PKG_NAME_REAL = iperf
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/esnet/$(PKG_NAME_REAL)/archive
PKG_DIST_FILE = $(PKG_NAME_REAL)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME_REAL)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://software.es.net/iperf/
COMMENT  = The iperf series of tools perform active measurements to determine the maximum achievable bandwidth on IP networks. It supports tuning of various parameters related to timing, protocols, and buffers. For each test it reports the measured throughput, loss, and other parameters.
LICENSE  = three-clause BSD

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

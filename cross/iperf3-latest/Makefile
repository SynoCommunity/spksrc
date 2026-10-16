PKG_NAME = iperf3
PKG_VERS = 3.22
PKG_EXT = tar.gz
PKG_NAME_REAL = iperf
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/esnet/iperf/archive
PKG_DIST_FILE = $(PKG_NAME_REAL)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME_REAL)-$(PKG_VERS)

DEPENDS = cross/openssl3

HOMEPAGE = https://software.es.net/iperf/
COMMENT  = The iperf series of tools perform active measurements to determine the maximum achievable bandwidth on IP networks. It supports tuning of various parameters related to timing, protocols, and buffers. For each test it reports the measured throughput, loss, and other parameters.
LICENSE  = 3-Clause BSD

# The virtual took this line everywhere except ARMv5 and DSM < 6, over libatomic, which
# iperf3 wants from 3.16 on. <stdatomic.h> itself is not a requirement: configure probes
# for it with and without -latomic and iperf builds without it, warning. One floor covers
# both halves -- 88f6281 ships gcc 4.6.4 and every DSM 5 toolchain 4.7.3 or older.
MIN_GCC_VERSION = 4.8

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
# prefer netinet/tcp.h over linux/tcp.h to ensure 'TCP_USER_TIMEOUT' is declared.
CONFIGURE_ARGS += ac_cv_header_linux_tcp_h=no
endif

include ../../mk/spksrc.cross-cc.mk

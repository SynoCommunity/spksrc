PKG_NAME = libnuma
PKG_VERS = 2.0.9
PKG_EXT = tar.gz
PKG_DIST_NAME = numactl-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://oss.sgi.com/www/projects/libnuma/download
PKG_DIR = numactl-$(PKG_VERS)
DEPENDS =

HOMEPAGE = http://oss.sgi.com/projects/libnuma/
COMMENT  = NUMA stands for Non-Uniform Memory Access,
LICENSE  = GPLv2

CONFIGURE_TARGET = myConf

GNU_CONFIGURE = 0

include ../../mk/spksrc.cross-cc.mk


myConf:
	echo "No-configure"


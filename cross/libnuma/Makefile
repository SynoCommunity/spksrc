PKG_NAME = libnuma
PKG_VERS = 2.0.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/numactl/numactl/archive/v$(PKG_VERS)
PKG_DIR = numactl-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://oss.sgi.com/projects/libnuma/
COMMENT  = NUMA stands for Non-Uniform Memory Access.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./autogen.sh

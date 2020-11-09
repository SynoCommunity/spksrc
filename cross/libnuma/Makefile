PKG_NAME = libnuma
PKG_VERS = 2.0.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/numactl/numactl/archive/v$(PKG_VERS)
PKG_DIR = numactl-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://linux.die.net/man/8/numactl
COMMENT  = NUMA stands for Non-Uniform Memory Access.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = libnuma_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: libnuma_pre_configure
libnuma_pre_configure:
	@$(RUN) ./autogen.sh

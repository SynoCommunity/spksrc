PKG_NAME = procps
PKG_VERS = 4.0.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.com/procps-ng/procps/-/archive/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS = cross/ncursesw cross/libiconv

HOMEPAGE = https://gitlab.com/procps-ng/procps
COMMENT  = procps is a set of command line and full-screen utilities that provide information out of the pseudo-filesystem most commonly located at /proc.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = procps_pre_configure

# Only the library is needed, disable tools
# DSM-7.2: Fails to build ‘__NR_pidfd_open’ undeclared
# ref: https://gitlab.com/procps-ng/procps/-/issues/352
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-pidof
CONFIGURE_ARGS += --disable-kill
CONFIGURE_ARGS += --disable-w
CONFIGURE_ARGS += --disable-modern-top

include ../../mk/spksrc.cross-cc.mk

.PHONY: procps_pre_configure
procps_pre_configure:
	$(RUN) ./autogen.sh

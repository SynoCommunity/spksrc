PKG_NAME = iperf2
PKG_VERS = 2.2.1
PKG_EXT = tar.gz
PKG_NAME_REAL = iperf
PKG_DIST_NAME = $(PKG_NAME_REAL)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/iperf2/files
PKG_DIR = $(PKG_NAME_REAL)-$(PKG_VERS)

DEPENDS =

# unsupported since v2.2.1 (errors compiling Server.cpp (including prague_cc.h)
#UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://sourceforge.net/projects/iperf2/
COMMENT  = A tool for measuring TCP and UDP network performance, based on iperf 2.0.5.
LICENSE  = BSD

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = iperf2_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: iperf2_post_install
iperf2_post_install:
	cd $(STAGING_INSTALL_PREFIX)/bin; ln -s ./iperf ./iperf2

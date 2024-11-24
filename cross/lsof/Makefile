PKG_NAME = lsof
PKG_VERS = 4.99.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lsof-org/lsof/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://lsof.readthedocs.io/
COMMENT  = lsof is a command listing open files.
LICENSE  = https://github.com/lsof-org/lsof/blob/master/COPYING

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-liblsof

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
# avoid error: 'NETLINK_SOCK_DIAG' undeclared for evansport-6.2.4
# evansport-7.1 does not find/use sock_diag anyway
CONFIGURE_ARGS += ac_cv_header_linux_sock_diag_h=no
endif

include ../../mk/spksrc.cross-cc.mk

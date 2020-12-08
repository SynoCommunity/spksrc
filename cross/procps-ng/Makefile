PKG_NAME = procps-ng
PKG_VERS = 3.3.8
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/$(PKG_NAME)/Production
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = https://sourceforge.net/projects/procps-ng/
COMMENT  = procps-ng is a fork of the procps project. It contains free, kill, pkill, pgrep, pmap, ps, pwdx, skill, slabtop, snice, sysctl, tload, top, uptime, vmstat, w, and watch.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk

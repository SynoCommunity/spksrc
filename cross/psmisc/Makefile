PKG_NAME = psmisc
PKG_VERS = 23.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.com/psmisc/psmisc/-/archive/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://gitlab.com/psmisc/psmisc
COMMENT  = Miscellaneous utilities that use the proc file-system
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = psmisc_preconfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: psmisc_preconfigure
psmisc_preconfigure:
	@$(MSG) "- patch configure.ac to support ncursesw"
	@$(RUN) sed -i -e 's/ncurses/ncursesw/g' configure.ac
	@$(RUN) ./autogen.sh

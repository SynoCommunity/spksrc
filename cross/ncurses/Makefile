PKG_NAME = ncurses_dispatcher

include which-ncurses.mk
ifeq ($(NCURSES_SUFFIX), w)
# NCursesW already started
  DEPENDS = cross/ncursesw
else
# Use NCurses
  DEPENDS = cross/ncurses_
endif

include dummy-pkg.mk

include ../../mk/spksrc.cross-cc.mk


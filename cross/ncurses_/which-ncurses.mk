ifneq ($(wildcard $(WORK_DIR)/.ncursesw-*), )
# ncursesW found
  NCURSES_ACTIVE = yes
  NCURSES_SUFFIX = w
else
  ifneq ($(wildcard $(WORK_DIR)/.ncurses-*), )
#   ncurses found
    NCURSES_ACTIVE = yes
    NCURSES_SUFFIX = 
  else
    ifneq ($NCURSES_SUFFIX), )
#     NCursesW explicitly requested
      NCURSES_ACTIVE = yes
      NCURSES_SUFFIX = w
    else
#     use ncurses
      NCURSES_ACTIVE = yes
      NCURSES_SUFFIX = 
    endif
  endif
endif

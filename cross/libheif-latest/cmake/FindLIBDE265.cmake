# FindLIBDE265.cmake - Find libde265 library
# This module is needed because libde265 doesn't ship cmake config files.

include(LibFindMacros)

libfind_pkg_check_modules(LIBDE265_PKGCONF libde265)

find_path(LIBDE265_INCLUDE_DIR
    NAMES libde265/de265.h
    HINTS ${LIBDE265_PKGCONF_INCLUDE_DIRS} ${LIBDE265_PKGCONF_INCLUDEDIR}
)

find_library(LIBDE265_LIBRARY
    NAMES libde265 de265
    HINTS ${LIBDE265_PKGCONF_LIBRARY_DIRS} ${LIBDE265_PKGCONF_LIBDIR}
)

set(LIBDE265_PROCESS_LIBS LIBDE265_LIBRARY)
set(LIBDE265_PROCESS_INCLUDES LIBDE265_INCLUDE_DIR)
libfind_process(LIBDE265)

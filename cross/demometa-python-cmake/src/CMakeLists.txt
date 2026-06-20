cmake_minimum_required(VERSION 3.10)
project(demometa-python-cmake C)

# Force pkg-config resolution of libraries provided by the python meta package
# (python314 ships libzstd and sqlite3). If the ordered PKG_CONFIG_LIBDIR
# reached this cross/ build, these resolve to the meta staging tree.
find_package(PkgConfig REQUIRED)
pkg_check_modules(ZSTD REQUIRED libzstd)
pkg_check_modules(SQLITE REQUIRED sqlite3)

add_executable(demometa-python-cmake main.c)
target_include_directories(demometa-python-cmake PRIVATE ${ZSTD_INCLUDE_DIRS} ${SQLITE_INCLUDE_DIRS})
target_link_directories(demometa-python-cmake PRIVATE ${ZSTD_LIBRARY_DIRS} ${SQLITE_LIBRARY_DIRS})
target_link_libraries(demometa-python-cmake PRIVATE ${ZSTD_LIBRARIES} ${SQLITE_LIBRARIES})

install(TARGETS demometa-python-cmake RUNTIME DESTINATION bin)

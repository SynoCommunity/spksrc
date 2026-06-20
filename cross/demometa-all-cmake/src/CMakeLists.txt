cmake_minimum_required(VERSION 3.10)
project(demometa-all-cmake C)

# Resolve libraries from TWO different meta packages in one build:
#   libzstd  <- python meta (python314)
#   dbus-1   <- videodriver meta (synocli-videodriver)
# Proves the ordered PKG_CONFIG_LIBDIR accumulates several metas at once.
find_package(PkgConfig REQUIRED)
pkg_check_modules(ZSTD REQUIRED libzstd)
pkg_check_modules(DBUS REQUIRED dbus-1)

add_executable(demometa-all-cmake main.c)
target_include_directories(demometa-all-cmake PRIVATE ${ZSTD_INCLUDE_DIRS} ${DBUS_INCLUDE_DIRS})
target_link_directories(demometa-all-cmake PRIVATE ${ZSTD_LIBRARY_DIRS} ${DBUS_LIBRARY_DIRS})
target_link_libraries(demometa-all-cmake PRIVATE ${ZSTD_LIBRARIES} ${DBUS_LIBRARIES})

install(TARGETS demometa-all-cmake RUNTIME DESTINATION bin)

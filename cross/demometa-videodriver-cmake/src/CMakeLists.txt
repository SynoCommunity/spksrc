cmake_minimum_required(VERSION 3.10)
project(demometa-videodriver-cmake C)

# Force pkg-config resolution of a library provided by the videodriver meta
# package (synocli-videodriver ships dbus-1). If the ordered PKG_CONFIG_LIBDIR
# reached this cross/ build, it resolves to the meta staging tree.
find_package(PkgConfig REQUIRED)
pkg_check_modules(DBUS REQUIRED dbus-1)

add_executable(demometa-videodriver-cmake main.c)
target_include_directories(demometa-videodriver-cmake PRIVATE ${DBUS_INCLUDE_DIRS})
target_link_directories(demometa-videodriver-cmake PRIVATE ${DBUS_LIBRARY_DIRS})
target_link_libraries(demometa-videodriver-cmake PRIVATE ${DBUS_LIBRARIES})

install(TARGETS demometa-videodriver-cmake RUNTIME DESTINATION bin)

cmake_minimum_required(VERSION 3.10)
project(demometa-ffmpeg-cmake C)

# Force pkg-config resolution of libraries provided by the ffmpeg meta package
# (ffmpeg7 ships libavcodec, libavformat). If the ordered PKG_CONFIG_LIBDIR
# reached this cross/ build, they resolve to the meta staging tree.
find_package(PkgConfig REQUIRED)
pkg_check_modules(AVCODEC REQUIRED libavcodec)
pkg_check_modules(AVFORMAT REQUIRED libavformat)

add_executable(demometa-ffmpeg-cmake main.c)
target_include_directories(demometa-ffmpeg-cmake PRIVATE ${AVCODEC_INCLUDE_DIRS} ${AVFORMAT_INCLUDE_DIRS})
target_link_directories(demometa-ffmpeg-cmake PRIVATE ${AVCODEC_LIBRARY_DIRS} ${AVFORMAT_LIBRARY_DIRS})
target_link_libraries(demometa-ffmpeg-cmake PRIVATE ${AVCODEC_LIBRARIES} ${AVFORMAT_LIBRARIES})

install(TARGETS demometa-ffmpeg-cmake RUNTIME DESTINATION bin)

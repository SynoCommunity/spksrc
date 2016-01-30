PKG_NAME = mpd
PKG_SHORT_VERS = 0.19
PKG_VERS = $(PKG_SHORT_VERS).12
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.musicpd.org/download/$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# 1. Dependencies
DEPENDS1  = cross/libtool cross/icu cross/glib cross/boost

# 2. Optional output dependencies
#EPENDS2  = cross/libao cross/fifo cross/alsa-lib cross/oss cross/pulseaudio cross/jack cross/libvorbis cross/lame cross/icecast cross/libshout cross/openal
DEPENDS2  = cross/libao            cross/alsa-lib           cross/pulseaudio cross/jack cross/libvorbis cross/lame cross/icecast cross/libshout cross/openal

# 3. Optional Input Dependencies
#EPENDS3a = cross/libid3tag cross/libmad cross/mpg123 cross/libogg cross/opus cross/flac cross/audiofile cross/faad2 cross/libmpcdec
DEPENDS3a = cross/libid3tag cross/libmad cross/mpg123 cross/libogg cross/opus cross/flac cross/audiofile cross/faad2 cross/libmpcdec

#EPENDS3b = cross/libmikmod cross/ffmpeg cross/sidplay2-libs cross/fluidsynth cross/wildmidi cross/libsndfile cross/libwavpack cross/adplug
DEPENDS3b = cross/libmikmod cross/ffmpeg cross/sidplay2-libs cross/fluidsynth                cross/libsndfile cross/libwavpack cross/adplug  

# 4. Optional Miscellaneous Dependencies
#EPENDS4a = cross/avahi cross/libsamplerate cross/curl cross/libmms cross/sqlite cross/libcdio-paranoia cross/libsystemd-daemon
DEPENDS4a =             cross/libsamplerate cross/curl cross/libmms cross/sqlite cross/libcdio-paranoia 

#EPENDS4b = cross/nfs-utils cross/libnfs cross/samba
DEPENDS4b =                 cross/libnfs 

# 5. Optional Miscellaneous Dependencies (from make)
#EPENDS5a = cross/tcp_wrappers cross/expat cross/bzip2 cross/libzzip cross/libmms cross/valgrind cross/libmpdclient
DEPENDS5a = cross/tcp_wrappers cross/expat cross/bzip2 cross/libzzip cross/libmms                cross/libmpdclient

#EPENDS5b = cross/libroar cross/libmodplug cross/twolame cross/libupnp
DEPENDS5b =               cross/libmodplug cross/twolame cross/libupnp

DEPENDS = $(DEPENDS1) $(DEPENDS2) $(DEPENDS3a) $(DEPENDS3b) $(DEPENDS4a) $(DEPENDS4b) $(DEPENDS5a) $(DEPENDS5b)

HOMEPAGE = http://www.musicpd.org/
COMMENT  = Flexible, powerful, server-side application for playing music
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-zzip
CONFIGURE_ARGS += --enable-iso9660
CONFIGURE_ARGS += --enable-mikmod
CONFIGURE_ARGS += --with-tremor
#CONFIGURE_ARGS += --enable-werror
#CONFIGURE_ARGS += --enable-documentation
CONFIGURE_ARGS += LIBMIKMOD_CONFIG=${WORK_DIR}/${PKG_DIR}/{${STAGING_INSTALL_PREFIX}

CONFIGURE_ARGS += --enable-python-binding 
CONFIGURE_ARGS += --with-boost-system=boost_system --with-boost-python=boost_python
CONFIGURE_ARGS += PYTHON=$(WORK_DIR)/../../../native/python/work-native/install/usr/local/bin/python
CONFIGURE_ARGS += PYTHON_CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/include/python2.7
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/python2.7
ADDITIONAL_LDFLAGS = "-Wl,-Bsymbolic"
ADDITIONAL_LDFLAGS += "-pthread"

BOOST_LIBRARIES += system python
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

PATCH_TARGET = patch_target myPatch
blank =

include ../../mk/spksrc.cross-cc.mk

myPatch:
	# Stop just after MPD Configuration
	sed -i -e "s/\(echo 'Generating files needed for compilation'\)/exit 1; \1/g" $(WORK_DIR)/$(PKG_DIR)/configure


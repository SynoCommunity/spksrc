PKG_NAME = mpd
PKG_VERS_SHORT = 0.19
PKG_VERS = $(PKG_SHORT_VERS).12
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://www.musicpd.org/download/$(PKG_NAME)/$(PKG_VERS_SHORT)

UNSUPPORTED_ARCHS += qoriq ppc853x

# 1. Dependencies
DEPENDS1  = cross/ncursesw cross/libtool cross/icu cross/glib cross/boost

# 2. Optional output dependencies
DEPENDS2  = cross/libao cross/alsa-utils cross/pulseaudio cross/jack cross/libvorbis cross/lame cross/icecast cross/libshout cross/openal cross/alsa-oss
#EPENDS2 += cross/mkfifo

# 3. Optional Input Dependencies
DEPENDS3  = cross/libid3tag cross/libmad cross/mpg123 cross/libogg cross/opus cross/flac cross/audiofile cross/faad2 cross/libmpcdec
DEPENDS3 += cross/libmikmod cross/ffmpeg cross/sidplay2-libs cross/fluidsynth cross/libsndfile cross/libwavpack cross/adplug
#EPENDS3 += cross/wildmidi 

# 4. Optional Miscellaneous Dependencies
DEPENDS4  = cross/avahi cross/libsamplerate cross/curl cross/libmms cross/sqlite cross/libcdio-paranoia cross/libnfs                                          
#EPENDS4 += cross/libsystemd-daemon cross/nfs-utils cross/samba

# 5. Optional Miscellaneous Dependencies (from make)
DEPENDS5  = cross/tcp_wrappers cross/expat cross/bzip2 cross/zziplib cross/libmms cross/libmpdclient
DEPENDS5 += cross/libmodplug cross/twolame cross/libupnp
#EPENDS5 += cross/roaraudio cross/valgrind 

DEPENDS = $(DEPENDS1) $(DEPENDS2) $(DEPENDS3) $(DEPENDS4) $(DEPENDS5) $(DEPENDS5)

HOMEPAGE = http://www.musicpd.org/
COMMENT  = Flexible, powerful, server-side application for playing music
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS  =
CONFIGURE_ARGS += --enable-eventfd          #use the function "eventfd" (default: auto)
CONFIGURE_ARGS += --enable-signalfd         #use the function "signalfd" (default: auto)
CONFIGURE_ARGS += --enable-poll             #use the function "poll" (default: auto)
CONFIGURE_ARGS += --enable-epoll            #use the function "epoll" (default: auto)
CONFIGURE_ARGS += --enable-database         #enable support for the music database
CONFIGURE_ARGS += --enable-libmpdclient     #enable support for the MPD client
CONFIGURE_ARGS += --enable-expat            #enable the expat XML parser
CONFIGURE_ARGS += --enable-upnp             #enable UPnP client support (default: auto)
CONFIGURE_ARGS += --enable-adplug           #enable the AdPlug decoder plugin (default: auto)
CONFIGURE_ARGS += --enable-alsa             #enable ALSA support
#ONFIGURE_ARGS += --enable-roar             #enable support for RoarAudio
CONFIGURE_ARGS += --enable-ao               #enable support for libao
CONFIGURE_ARGS += --enable-audiofile        #enable audiofile support (WAV and others)
CONFIGURE_ARGS += --enable-zlib             #enable zlib support (default: auto)
CONFIGURE_ARGS += --enable-bzip2            #enable bzip2 archive support (default: auto)
CONFIGURE_ARGS += --enable-cdio-paranoia    #enable support for audio CD support
CONFIGURE_ARGS += --enable-curl             #enable support for libcurl HTTP streaming (default: auto)
#ONFIGURE_ARGS += --enable-smbclient        #enable support for libsmbclient (default: auto)
CONFIGURE_ARGS += --enable-nfs              #enable support for libnfs (default: auto)
#ONFIGURE_ARGS += --enable-documentation    #build documentation (default: disable)
CONFIGURE_ARGS += --enable-dsd              #enable DSD decoder (default: enable)
CONFIGURE_ARGS += --enable-ffmpeg           #enable FFMPEG support
#ONFIGURE_ARGS += --disable-fifo            #disable support for writing audio to a FIFO (default: enable)
CONFIGURE_ARGS += --enable-flac             #enable FLAC decoder
CONFIGURE_ARGS += --enable-fluidsynth       #enable MIDI support via fluidsynth (default: auto)
#ONFIGURE_ARGS += --enable-gme              #enable Blargg's game music emulator plugin
CONFIGURE_ARGS += --enable-httpd-output     #enables the HTTP server output
CONFIGURE_ARGS += --enable-id3              #enable id3 support
#ONFIGURE_ARGS += --disable-inotify         #disable support Inotify automatic database update (default: enabled)
#ONFIGURE_ARGS += --disable-ipv6            #disable IPv6 support (default: enable)
CONFIGURE_ARGS += --enable-iso9660          #enable iso9660 archive support (default: disabled)
CONFIGURE_ARGS += --enable-jack             #enable jack support
#ONFIGURE_ARGS += --disable-largefile       #omit support for large files
#ONFIGURE_ARGS += --enable-soundcloud       #enable support for soundcloud.com
CONFIGURE_ARGS += --enable-lame-encoder     #enable the LAME mp3 encoder
CONFIGURE_ARGS += --enable-libwrap          #use libwrap
CONFIGURE_ARGS += --enable-lsr              #enable libsamplerate support
#ONFIGURE_ARGS += --enable-soxr             #enable the libsoxr resampler
CONFIGURE_ARGS += --enable-mad              #enable libmad mp3 decoder plugin
CONFIGURE_ARGS += --enable-mikmod           #enable the mikmod decoder (default: disable)
CONFIGURE_ARGS += --enable-mms              #enable the MMS protocol with libmms
CONFIGURE_ARGS += --enable-modplug          #enable modplug decoder plugin
#ONFIGURE_ARGS += --enable-mpc              #disable musepack (MPC) support (default: auto)
CONFIGURE_ARGS += --enable-mpg123           #enable libmpg123 decoder plugin
#ONFIGURE_ARGS += --enable-openal           #enable OpenAL support (default: auto)
CONFIGURE_ARGS += --enable-opus             #enable Opus codec support (default: auto)
CONFIGURE_ARGS += --enable-oss              #disable OSS support (default: enable)
#ONFIGURE_ARGS += --enable-osx              #enable the OS X output plugin - unsupported! (default: disable)
#ONFIGURE_ARGS += --enable-pipe-output      #enable support for writing audio to a pipe (default: disable)
CONFIGURE_ARGS += --enable-pulse            #enable support for the PulseAudio sound server
#ONFIGURE_ARGS += --enable-recorder-output  #enables the recorder file output plugin (default: disable)
CONFIGURE_ARGS += --enable-sidplay          #enable C64 SID support via libsidplay2
#ONFIGURE_ARGS += --enable-shine-encoder    #enables shine encoder
CONFIGURE_ARGS += --enable-shout            #enables the shoutcast streaming output
CONFIGURE_ARGS += --enable-sndfile          #enable sndfile support
#ONFIGURE_ARGS += --enable-solaris-output   #enables the Solaris /dev/audio output
CONFIGURE_ARGS += --enable-sqlite           #enable support for the SQLite database
#ONFIGURE_ARGS += --enable-systemd-daemon   #use the systemd daemon library (default=auto)
#ONFIGURE_ARGS += --disable-tcp             #disable support for clients connecting via TCP (default: enable)
#ONFIGURE_ARGS += --enable-test             #build the test programs (default: disabled)
CONFIGURE_ARGS += --enable-twolame-encoder  #enable the TwoLAME mp2 encoder
#ONFIGURE_ARGS += --disable-un              #disable support for clients connecting via unix domain sockets (default: enable)
CONFIGURE_ARGS += --enable-vorbis           #enable Ogg Vorbis decoder
CONFIGURE_ARGS += --enable-vorbis-encoder   #enable the Ogg Vorbis encoder
CONFIGURE_ARGS += --enable-wave-encoder     #enable the PCM wave encoder
CONFIGURE_ARGS += --enable-wavpack          #enable WavPack support
#ONFIGURE_ARGS += --enable-werror           #treat warnings as errors (default: disabled)
#ONFIGURE_ARGS += --enable-wildmidi         #enable MIDI support via wildmidi (default: auto)
CONFIGURE_ARGS += --enable-zzip             #enable zip archive support (default: disabled)
CONFIGURE_ARGS += --enable-icu              #enable libicu for Unicode (default: enabled)
CONFIGURE_ARGS += --enable-glib             #enable GLib usage (default: enabled)
CONFIGURE_ARGS += --enable-neighbor-plugins #enable support for neighbor discovery (default: auto)
#ONFIGURE_ARGS += --disable-aac             #disable AAC support (default: enable)

#ONFIGURE_ARGS += --enable-python-binding 
#ONFIGURE_ARGS += --with-boost-system=boost_system --with-boost-python=boost_python
CONFIGURE_ARGS += PYTHON=$(WORK_DIR)/../../../native/python/work-native/install/usr/local/bin/python
CONFIGURE_ARGS += PYTHON_CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/include/python2.7
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/python2.7
ADDITIONAL_LDFLAGS = "-Wl,-Bsymbolic"
ADDITIONAL_LDFLAGS += "-pthread"

BOOST_LIBRARIES += system python
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.cross-cc.mk


SPK_NAME = tvheadend
SPK_SHORT_VERS = 4.3
SPK_GIT_HASH = 9102efaf
SPK_GIT_DATE = 20260525
SPK_VERS = $(SPK_SHORT_VERS).$(SPK_GIT_DATE)
TVH_VERS = $(SPK_SHORT_VERS)~$(SPK_GIT_HASH)
SPK_REV = 48
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

FFMPEG_PACKAGE = ffmpeg7
PYTHON_PACKAGE = python314

#GCC_DEBUG_INFO := 1

MAINTAINER = th0ma7
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
DESCRIPTION_FRE = Tvheadend est un serveur de streaming et enregistreur TV pour Linux, FreeBSD et Android prenant en charge DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP et HDHomeRun comme sources d\'entrée. Tvheadend offre le streaming HTTP, HTSP et SAT IP.
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG = "1. Update to latest git version 9102efaf of May 25th 2026<br/>2. Update all python wheels<br/>3. Fix for gracenote2epg install<br/>4. Enablement of dbus<br/>5. Experimental migration to ffmpeg 8.1<br/>6. Enable new experimental vue UI<br/>7. Update libhdhomerun to 20260313<br/>8. Migrate to python 3.14"
HOMEPAGE = https://tvheadend.org/
LICENSE = GPL v3

CONF_DIR = src/conf/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
# Debug builds (GCC_DEBUG_INFO=1) ship a start-up script with an optional gdb
# crash-backtrace mode (toggle at runtime: touch ${SYNOPKG_PKGVAR}/gdb-debug.flag);
# release builds get the plain start-up script.
ifeq ($(strip $(GCC_DEBUG_INFO)),1)
SERVICE_SETUP = src/service-setup-dbg.sh
else
SERVICE_SETUP = src/service-setup.sh
endif

# Service configuration
SERVICE_PORT = 9981
SERVICE_PORT_TITLE = Tvheadend (HTTP)

# Admin link
ADMIN_PORT = ${SERVICE_PORT}

# PPC archs except qoriq are not supported
#    https://tvheadend.org/issues/5060
# ffmpeg-7 no longer support 88f6281 (armv5) and ffmpeg-7.1 hi3535 (armv7l)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

DEPENDS  = cross/tvheadend
DEPENDS += cross/dtv-scan-tables
DEPENDS += cross/docker-tvheadend
DEPENDS += cross/zap2epg

OPTIONAL_DEPENDS += python/numpy-latest
OPTIONAL_DEPENDS += python/pandas

WHEELS += src/requirements-pure.txt

# Use media and other libraries from FFMPEG_PACKAGE shared libraries
MEDIA_LIBS  = fdk-aac.pc
MEDIA_LIBS += fontconfig.pc
MEDIA_LIBS += ogg.pc
MEDIA_LIBS += opus.pc
MEDIA_LIBS += libpcre2-8.pc
MEDIA_LIBS += libpcre2-32.pc
MEDIA_LIBS += libpcre2-posix.pc
MEDIA_LIBS += theoradec.pc
MEDIA_LIBS += theoraenc.pc
MEDIA_LIBS += theora.pc
MEDIA_LIBS += vorbisenc.pc
MEDIA_LIBS += vorbisfile.pc
MEDIA_LIBS += vorbis.pc
MEDIA_LIBS += vpx.pc
MEDIA_LIBS += x264.pc
MEDIA_LIBS += x265.pc

include ../../mk/spksrc.common.mk

# Optional gracenote2epg dependencies
ifeq ($(call version_ge, $(TC_GCC), 8.5),1)
# [numpy]
DEPENDS += python/numpy-latest

# [pandas]
DEPENDS += python/pandas
endif

# [pandas] https://github.com/th0ma7/gracenote2epg/issues/8
WHEELS += pgeocode==0.5.0

# Export version to the build where version
# script gets patched accordingly by:
# 000-fix-version.patch from cross/tvheadend
export TVH_VERS

include ../../mk/spksrc.spk-meta.mk

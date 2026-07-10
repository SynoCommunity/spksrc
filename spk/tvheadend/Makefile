SPK_NAME = tvheadend
SPK_SHORT_VERS = 4.3
SPK_GIT_HASH = 0ad5b1a3
SPK_GIT_DATE = 20260709
SPK_VERS = $(SPK_SHORT_VERS).$(SPK_GIT_DATE)
TVH_VERS = $(SPK_SHORT_VERS)~$(SPK_GIT_HASH)
SPK_REV = 49
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

FFMPEG_PACKAGE = ffmpeg8
PYTHON_PACKAGE = python314

#GCC_DEBUG_INFO := 1

MAINTAINER = th0ma7
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
DESCRIPTION_FRE = Tvheadend est un serveur de streaming et enregistreur TV pour Linux, FreeBSD et Android prenant en charge DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP et HDHomeRun comme sources d\'entrée. Tvheadend offre le streaming HTTP, HTSP et SAT IP.
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG  = "1. Update to latest git version 0ad5b1a3 of July 9th 2026<br/>"
CHANGELOG += "2. Update all python wheels<br/>"
CHANGELOG += "3. Update to gracenote2epg 2.0<br/>"
CHANGELOG += "4. Enablement of dbus<br/>"
CHANGELOG += "5. Experimental migration to ffmpeg 8.1<br/>"
CHANGELOG += "6. New Vue web UI (now upstream in tvheadend)<br/>"
CHANGELOG += "7. Update libhdhomerun to 20260313<br/>"
CHANGELOG += "8. Migrate to python 3.14<br/>"
CHANGELOG += "9. Removal of zap2epg as replaced with gracenote2epg<br/>"
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

WHEELS += src/requirements-pure.txt

# Export version to the build where version
# script gets patched accordingly by:
# 000-fix-version.patch from cross/tvheadend
export TVH_VERS

POST_SERVICE_TARGET = tvh_post_service

include ../../mk/spksrc.spk-meta.mk

.PHONY: tvh_post_service
tvh_post_service:
	sed -i -e 's/_PYTHON_PACKAGE_/$(PYTHON_PACKAGE)/g' \
	       -e 's/_FFMPEG_PACKAGE_/$(FFMPEG_PACKAGE)/g' \
	           $(WORK_DIR)/scripts/service-setup

SPK_NAME = tvheadend
SPK_SHORT_VERS = 4.3
SPK_GIT_HASH = 0b23983f
SPK_GIT_DATE = 20251114
SPK_VERS = $(SPK_SHORT_VERS).$(SPK_GIT_DATE)
TVH_VERS = $(SPK_SHORT_VERS)~$(SPK_GIT_HASH)
SPK_REV = 45
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

FFMPEG_PACKAGE = ffmpeg7
PYTHON_PACKAGE = python312
SPK_DEPENDS = 'python312:$(FFMPEG_PACKAGE)'

MAINTAINER = th0ma7
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
DESCRIPTION_FRE = Tvheadend est un serveur de streaming et enregistreur TV pour Linux, FreeBSD et Android prenant en charge DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP et HDHomeRun comme sources d\'entrée. Tvheadend offre le streaming HTTP, HTSP et SAT IP.
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG = "1. Update to latest git version 0b23983f as of November 14th 2025<br/>2. TVH crash with NULL codec before encoder open<br/>3. Update gracenote2epg grabber v1.6.0<br/>4. Update libhdhomerun v20250815"
HOMEPAGE = https://tvheadend.org/
LICENSE = GPL v3

CONF_DIR = src/conf/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 9981
SERVICE_PORT_TITLE = Tvheadend (HTTP)

# Admin link
ADMIN_PORT = ${SERVICE_PORT}

# PPC archs except qoriq are not supported
# https://tvheadend.org/issues/5060
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

DEPENDS = cross/tvheadend
DEPENDS += cross/dtv-scan-tables
DEPENDS += cross/docker-tvheadend
DEPENDS += cross/zap2epg

OPTIONAL_DEPENDS += python/numpy
OPTIONAL_DEPENDS += python/pandas

WHEELS += src/requirements-pure.txt

include ../../mk/spksrc.common.mk

# Optional gracenote2epg dependencies
ifeq ($(call version_ge, $(TC_GCC), 8.5),1)
# [numpy]
DEPENDS += python/numpy

# [pandas]
DEPENDS += python/pandas
endif

# Export version to the build where version
# script gets patched accordingly by:
# 000-fix-version.patch from cross/tvheadend
export TVH_VERS

include ../../mk/spksrc.python.mk

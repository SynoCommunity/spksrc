SPK_NAME = tvheadend
SPK_SHORT_VERS = 4.3
SPK_GIT_HASH = ec0469c1
SPK_GIT_DATE = 20250820
SPK_VERS = $(SPK_SHORT_VERS).$(SPK_GIT_DATE)
TVH_VERS = $(SPK_SHORT_VERS)~$(SPK_GIT_HASH)
SPK_REV = 44
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

# Export version to the build where version
# script gets patched accordingly by:
# 000-fix-version.patch from cross/tvheadend
export TVH_VERS

FFMPEG_PACKAGE = ffmpeg7
PYTHON_PACKAGE = python312
SPK_DEPENDS = 'python312:$(FFMPEG_PACKAGE)'

# PPC archs except qoriq are not supported
# https://tvheadend.org/issues/5060
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

# Force building pure-python wheels to include gracenote2epg
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1
WHEELS += src/requirements-pure.txt

DEPENDS = cross/tvheadend
DEPENDS += cross/dtv-scan-tables
DEPENDS += cross/docker-tvheadend
DEPENDS += cross/zap2epg

MAINTAINER = th0ma7
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
DESCRIPTION_FRE = Tvheadend est un serveur de streaming et enregistreur TV pour Linux, FreeBSD et Android prenant en charge DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP et HDHomeRun comme sources d\'entrée. Tvheadend offre le streaming HTTP, HTSP et SAT IP.
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG = "1. Update to latest git version ec0469c1 as of August 20th 2025 \(Includes season and episode number to filename formatting, Add scene markers to recordings, Add age ratings on XMLTV\)<br/>2. Update zap2epg to version 4.1<br/> 3. Include new gracenote2epg grabber v1.4.1"
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

include ../../mk/spksrc.python.mk

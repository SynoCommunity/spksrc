SPK_NAME = tvheadend
SPK_SHORT_VERS = 4.3
SPK_GIT_HASH = 808a87a
SPK_GIT_DATE = 20250604
SPK_VERS = $(SPK_SHORT_VERS).$(SPK_GIT_DATE)
TVH_VERS = $(SPK_SHORT_VERS)~$(SPK_GIT_HASH)
SPK_REV = 43
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

# Export version to the build where version
# script gets patched accordingly by:
# 000-fix-version.patch from cross/tvheadend
export TVH_VERS

FFMPEG_PACKAGE = ffmpeg7
SPK_DEPENDS = 'python312:$(FFMPEG_PACKAGE)'

# PPC archs except qoriq are not supported
# https://tvheadend.org/issues/5060
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)


WHEELS = src/requirements-pure.txt

DEPENDS = cross/tvheadend
DEPENDS += cross/dtv-scan-tables
DEPENDS += cross/zap2epg cross/docker-tvheadend

MAINTAINER = th0ma7
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
DESCRIPTION_FRE = Tvheadend est un serveur de streaming et enregistreur TV pour Linux, FreeBSD et Android prenant en charge DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP et HDHomeRun comme sources d\'entrée. Tvheadend offre le streaming HTTP, HTSP et SAT IP.
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG = "1. Update to latest git version 20250604 as of June 4th 2025"
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

include ../../mk/spksrc.ffmpeg.mk

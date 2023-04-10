SPK_NAME = tvheadend
SPK_SHORT_VERS = 4.3
SPK_GIT_HASH = f32c7c5
SPK_GIT_DATE = 20230408
SPK_VERS = $(SPK_SHORT_VERS).$(SPK_GIT_DATE)
TVH_VERS = $(SPK_SHORT_VERS)~$(SPK_GIT_HASH)
SPK_REV = 36
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

# Export version to the build where version
# script gets patched accordingly by:
# 000-fix-version.patch from cross/tvheadend
export TVH_VERS

SPK_DEPENDS = "python310"

WHEELS = src/requirements-pure.txt

DEPENDS = cross/$(SPK_NAME)
DEPENDS += cross/dtv-scan-tables
DEPENDS += cross/zap2epg cross/docker-tvheadend

MAINTAINER = th0ma7
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
DESCRIPTION_FRE = Tvheadend est un serveur de streaming et enregistreur TV pour Linux, FreeBSD et Android prenant en charge DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP et HDHomeRun comme sources d\'entrée. Tvheadend offre le streaming HTTP, HTSP et SAT IP.
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG = "1. Update to latest git version f32c7c5 as of April 8th 2023<br/>2. Update FFMPEG 5.1.2<br/>3. Update libhdhomerun to version 20230323"
HOMEPAGE = https://tvheadend.org/
LICENSE = GPL v3

# PPC archs except qoriq are not supported
# https://tvheadend.org/issues/5060
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

CONF_DIR = src/conf/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 9981
SERVICE_PORT_TITLE = Tvheadend(HTTP)

# Admin link
ADMIN_PORT = ${SERVICE_PORT}

# Reuse ffmpeg libraries
export FFMPEG_VERSION = 5
export FFMPEG_DIR = $(realpath $(shell pwd)/../ffmpeg$(FFMPEG_VERSION)/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg$(subst 4,,$(FFMPEG_VERSION))/target)

ifneq ($(wildcard $(FFMPEG_DIR)),)
export ADDITIONAL_LDFLAGS = -Wl,--rpath-link,$(FFMPEG_DIR)/lib -Wl,--rpath,/var/packages/ffmpeg$(subst 4,,$(FFMPEG_VERSION))/target/lib
PRE_DEPEND_TARGET = tvheadend_pre_depend
SPK_DEPENDS := "$(SPK_DEPENDS):ffmpeg$(subst 4,,$(FFMPEG_VERSION))>$(shell sed -n 's/^SPK_VERS = \(.*\)/\1/p' $(shell pwd)/../ffmpeg$(FFMPEG_VERSION)/Makefile | cut -c -3)"
endif

include ../../mk/spksrc.spk.mk

.PHONY: tvheadend_pre_depend tvheadend_extra_install

# Use FFMPEG package shared libraries
FFMPEG_LIBS  = libavfilter.pc
FFMPEG_LIBS += libpostproc.pc
FFMPEG_LIBS += libswresample.pc
FFMPEG_LIBS += libswscale.pc
FFMPEG_LIBS += libavutil.pc
FFMPEG_LIBS += libavformat.pc
FFMPEG_LIBS += libavcodec.pc

# Use other media libraries through FFMPEG package shared libraries
MEDIA_LIBS  = fdk-aac.pc
MEDIA_LIBS += ogg.pc
MEDIA_LIBS += opus.pc
MEDIA_LIBS += theoradec.pc
MEDIA_LIBS += theoraenc.pc
MEDIA_LIBS += theora.pc
MEDIA_LIBS += vorbisenc.pc
MEDIA_LIBS += vorbisfile.pc
MEDIA_LIBS += vorbis.pc
MEDIA_LIBS += vpx.pc
MEDIA_LIBS += x264.pc
MEDIA_LIBS += x265.pc

# Add Intel VAAPI libraries on Intel platforms
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
VAAPI_LIBS  = libdrm.pc
VAAPI_LIBS += libdrm_intel.pc
VAAPI_LIBS += libva.pc
VAAPI_LIBS += libva-drm.pc
VAAPI_LIBS += pciaccess.pc
endif

tvheadend_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sfT $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) ;)
	$(foreach lib,$(MEDIA_LIBS),ln -sfT $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) ;)
	$(foreach lib,$(VAAPI_LIBS),ln -sfT $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) ;)

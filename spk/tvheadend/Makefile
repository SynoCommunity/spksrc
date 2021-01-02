SPK_NAME = tvheadend
SPK_SHORT_VERS = 4.3
SPK_GIT_HASH = 9ed76c0
SPK_GIT_DATE = 20201011
SPK_VERS = $(SPK_SHORT_VERS).$(SPK_GIT_DATE)~$(SPK_GIT_HASH)
TVH_VERS = $(SPK_SHORT_VERS)~$(SPK_GIT_HASH)
SPK_REV = 26
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

# Export version to the build where version
# script gets patched accordingly by:
# 000-fix-version.patch from cross/tvheadend
export TVH_VERS

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
RELOAD_UI = yes
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG = "1. Update to latest git version 9ed76c0 as of October 11th 2020<br/>2. Update openssl to 1.1"
HOMEPAGE = https://tvheadend.org/
LICENSE = GPL v3

# PPC archs except qoriq are not supported
# https://tvheadend.org/issues/5060
UNSUPPORTED_ARCHS = $(OLD_PCC_ARCHS)

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 9981
SERVICE_PORT_TITLE = Tvheadend(HTTP)

# Admin link
ADMIN_PORT = ${SERVICE_PORT}

POST_STRIP_TARGET = tvheadend_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

# Reuse ffmpeg libraries
# Requires to invoke: make [package|publish] ARCH= TCVERSION=
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
PRE_DEPEND_TARGET = tvheadend_pre_depend
SPK_DEPENDS = "ffmpeg>4.1"
endif

include ../../mk/spksrc.spk.mk

.PHONY: tvheadend_pre_depend tvheadend_extra_install

# Use FFMPEG package shared libraries
FFMPEG_LIBS = libavfilter.pc libpostproc.pc libswresample.pc libavresample.pc libswscale.pc libavutil.pc libavformat.pc libavcodec.pc

# Use other media libraries through FFMPEG package shared libraries
MEDIA_LIBS = fdk-aac.pc numa.pc ogg.pc opus.pc theoradec.pc theoraenc.pc theora.pc vorbisenc.pc vorbisfile.pc vorbis.pc vpx.pc x264.pc x265.pc

# Add Intel VAAPI libraries on Intel platforms
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
VAAPI_LIBS = libdrm.pc libdrm_intel.pc libkms.pc libva.pc libva-drm.pc pciaccess.pc
endif

tvheadend_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sfT $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) ;)
	$(foreach lib,$(MEDIA_LIBS),ln -sfT $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) ;)
	$(foreach lib,$(VAAPI_LIBS),ln -sfT $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) ;)

tvheadend_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/accesscontrol
	install -m 755 -d $(STAGING_DIR)/var/passwd
	# The following filenames stem from an arbitrary (valid) combination created by TVH
	install -m 644 src/accesscontrol.json $(STAGING_DIR)/var/accesscontrol/d80ccc09630261ffdcae1497a690acc8
	install -m 644 src/passwd.json $(STAGING_DIR)/var/passwd/a927e30a755504f9784f23a4efac5109

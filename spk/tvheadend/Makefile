SPK_NAME = tvheadend
SPK_VERS = 4.2.8
SPK_REV = 16
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = m4tt075
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
RELOAD_UI = yes
DISPLAY_NAME = Tvheadend
STARTABLE = yes
CHANGELOG = "1. Fix CA module support regression<br/>2. Fix regression of upgrading legacy packages<br/>3. Simplify and fix initial login credential setting"
HOMEPAGE = https://www.lonelycoder.com/tvheadend/
LICENSE = GPL v3

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

include ../../mk/spksrc.common.mk

# Reuse ffmpeg libraries
# Requires to invoke: make [package|publish] ARCH= TCVERSION=
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
PRE_DEPEND_TARGET = tvheadend_pre_depend
SPK_DEPENDS = "ffmpeg>4.1"
endif

include ../../mk/spksrc.spk.mk

.PHONY: tvheadend_pre_depend tvheadend_extra_install

FFMPEG_LIBS = libavfilter.pc libpostproc.pc libswresample.pc libavresample.pc libswscale.pc libavutil.pc libavformat.pc libavcodec.pc

tvheadend_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -s $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

tvheadend_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/accesscontrol
	install -m 755 -d $(STAGING_DIR)/var/passwd
	# The following filenames stem from an arbitrary (valid) combination created by TVH
	install -m 644 src/accesscontrol.json $(STAGING_DIR)/var/accesscontrol/d80ccc09630261ffdcae1497a690acc8
	install -m 644 src/passwd.json $(STAGING_DIR)/var/passwd/a927e30a755504f9784f23a4efac5109

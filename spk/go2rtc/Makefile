SPK_NAME = go2rtc
SPK_VERS = 1.6.2
SPK_REV = 1
SPK_ICON = src/go2rtc.png
DSM_UI_DIR = app

DEPENDS = cross/go2rtc

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = AlexxIT
DESCRIPTION = Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MP4, MJPEG, HomeKit, FFmpeg, etc
DISPLAY_NAME = go2rtc
CHANGELOG = "1. "
LICENSE_FILE = $(WORK_DIR)/src/github.com/go2rtc/go2rtc/LICENSE
HOMEPAGE = https://github.com/AlexxIT/go2rtc
LICENSE = MIT

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
FWPORTS = src/go2rtc.sc
# Console Port (API Port is 1984)
ADMIN_PORT = 1984

#OST_STRIP_TARGET = go2rtc_extra_install

SPK_COMMANDS = bin/go2rtc

include ../../mk/spksrc.spk.mk

#.PHONY: go2rtc_extra_install
#go2rtc_extra_install:
#	@install -d -m 755 $(STAGING_DIR)/var
#	@install -m 644 src/environment-variables $(STAGING_DIR)/var/

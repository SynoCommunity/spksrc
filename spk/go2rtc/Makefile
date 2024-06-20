SPK_NAME = go2rtc
SPK_VERS = 1.9.4
SPK_REV = 5
SPK_ICON = src/go2rtc.png

DEPENDS = cross/go2rtc

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = skrashevich
DESCRIPTION = Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MP4, MJPEG, HomeKit, FFmpeg, etc
DISPLAY_NAME = go2rtc
CHANGELOG = "go2rtc updated to v1.9.4"
LICENSE_FILE = $(WORK_DIR)/src/github.com/go2rtc-$(SPK_VERS)/LICENSE
HOMEPAGE = https://github.com/AlexxIT/go2rtc
LICENSE = MIT

WIZARDS_DIR = src/wizard

FWPORTS = src/go2rtc.sc
# Console Port (API and web UI Port)
ADMIN_PORT = 1984

SERVICE_USER = auto
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = go2rtc_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: go2rtc_extra_install
go2rtc_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/go2rtc.yaml $(STAGING_DIR)/var/

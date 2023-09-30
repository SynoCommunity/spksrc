SPK_NAME = go2rtc
SPK_VERS = 1.7.1
SPK_REV = 1
SPK_ICON = src/go2rtc.png
DSM_UI_DIR = app

DEPENDS = cross/go2rtc

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = skrashevich
DESCRIPTION = Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MP4, MJPEG, HomeKit, FFmpeg, etc
DISPLAY_NAME = go2rtc
CHANGELOG = "Add support HomeKit doorbells pairing (ex. Aqara G4)<br />Add support webrtc go2rtc source with auth \#539<br />Restore fix for Chinese buggy cameras \#607<br />Update default connection deadline from 3 to 5 seconds<br />Update libs dependencies<br />Fix changing config via WebUI and HomeKit simultaneously<br />Fix save pairings for HomeKit server in some cases<br />Fix HomeKit pairing for some cameras<br />Fix malformed HTTP version for HomeKit source \#620<br />Fix panic for HomeKit source<br />Add HomeKit Server<br /><br />Add support output any H264 camera to Apple HomeKit<br />Add support transparent proxy for HomeKit cameras (Aqara, etc.)<br />Total rework<br /><br />Remove almost all external libraries (dependencies) except pion/WebRTC and rewrited that formats/parsers from scratch<br />Total rework HomeKit source<br />including native AAC-ELD audio support for FFmpeg<br />Total rework RTMP/RTMPS source<br />Total rework HTTP-FLV source<br />Total rework MPEG-TS source:<br />including rework TP-Link Tapo source<br />add support IPTV streams with B-frames and AAC audio<br />add support MPEG-TS for HLS source<br />Rework RTSP server (consumer) for less CPU usage<br />Rework JPEG source<br />Rework MJPEG source<br />Rework Magic (pipe/tcp/http) source<br />Rework MP4, HLS, MPEG-TS, MJPEG consumers<br />Rework HomeKit pairing WebUI<br />Rework Discovery API for all sources<br />Support for adding and removing streams in go2rtc.yaml with preserving file formatting<br />Remove storage as go2rtc.json file, all changes now go to go2rtc.yaml<br />Add support simple HLS/TS source<br />Add support RTMPS source<br />Add support MJPEG codec for HomeKit source<br />Add support OpenIPC WebRTC format as source<br />Add SDP to stream.json info<br />Add insecure HTTPS requests to IP addresses<br />Add new H265 codec to DVRIP source \#561 by @dbuezas<br />Add check for empty H265 packet \#589<br />Add autobild binaries (artifacts) for master (dev) version<br />Add support B-frames for MP4 consumer<br />Add ffplay example to WebUI links page<br />Support hass source without hass config \#541<br />Update FFmpeg preset for OPUS<br />Update WebUI config editor \#593 by @skrashevich<br />Update Go version to 1.21 \#592 by @skrashevich<br />Update FFmpeg flags for hardware vaapi \#557 by @h0nIg<br />Update readme about wyze-bridge \#588<br />Improve mDNS handler<br />Fix config file validating<br />Fix support more TP-Link cameras RTSP \#567 by @awatuna<br />Fix H264 profile parsing for OpenIPC RTSP source<br />Fix 400 response on PLAY for Reolink Doorbell \#562<br />Fix redirect for rtspx source \#565<br />Fix WebUI background color for dark mode browser<br />Fix H265 codec for bubble source"
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

PKG_NAME = go2rtc
PKG_VERS = 1.8.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AlexxIT/go2rtc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_NAME)
PKG_DIR = src/github.com/$(PKG_NAME)/$(PKG_NAME)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/AlexxIT/go2rtc/
COMMENT  = Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MP4, MJPEG, HomeKit, FFmpeg, etc.
LICENSE  = MIT

POST_EXTRACT_TARGET = go2rtc_post_extract

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS = -trimpath
GO_LDFLAGS = -s -w

include ../../mk/spksrc.cross-go.mk

.PHONY:  go2rtc_post_extract
go2rtc_post_extract:
	@$(MSG) Rename extracted folder to make imports work when used as GOPATH
	cd $(EXTRACT_PATH) && [ -d "$(PKG_NAME)-$(PKG_VERS)" ] && mv "$(PKG_NAME)-$(PKG_VERS)" $(PKG_NAME)
	cd "$(EXTRACT_PATH)/$(PKG_NAME)" && env $(ENV) go get github.com/tillberg/autorestart

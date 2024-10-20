PKG_NAME = go2rtc
PKG_VERS = 1.9.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AlexxIT/go2rtc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/AlexxIT/go2rtc/
COMMENT  = Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MP4, MJPEG, HomeKit, FFmpeg, etc.
LICENSE  = MIT

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS = -trimpath
GO_LDFLAGS = -s -w

include ../../mk/spksrc.cross-go.mk

PKG_NAME = go2rtc
PKG_VERS = 1.9.14
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AlexxIT/go2rtc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
include ../../mk/spksrc.common.mk
# Both go tiers, for the dependency scan: it runs with no ARCH, where the conditional
# below collapses to one branch and the other tier becomes invisible to CI.
# OPTIONAL_DEPENDS is the superset that scan reads (mk/spksrc.rules/dependency-tree.mk).
OPTIONAL_DEPENDS = native/go native/go_1.23
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
BUILD_DEPENDS = native/go_1.23
NATIVE_GO = native/go_1.23
else
BUILD_DEPENDS = native/go
NATIVE_GO = native/go
endif

HOMEPAGE = https://github.com/AlexxIT/go2rtc/
COMMENT  = Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MP4, MJPEG, HomeKit, FFmpeg, etc.
LICENSE  = MIT

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS = -trimpath
GO_LDFLAGS = -s -w

include ../../mk/spksrc.cross-go.mk

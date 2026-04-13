PKG_NAME = srt
PKG_VERS = 1.5.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Haivision/srt/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

HOMEPAGE = https://github.com/Haivision/srt
COMMENT  = Secure Reliable Transport (SRT) is a transport protocol for ultra low (sub-second) latency live video and audio streaming, as well as for generic bulk data transfer1. SRT is available as an open-source technology with the code on GitHub, a published Internet Draft, and a growing community of SRT users.
LICENSE  = MPLv2.0 License

include ../../mk/spksrc.cross-cmake.mk

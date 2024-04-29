PKG_NAME = darkstat
PKG_VERS = 3.0.721
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/emikulic/darkstat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libpcap

HOMEPAGE = https://unix4lyfe.org/darkstat
COMMENT  = Captures network traffic, calculates statistics about usage, and serves reports over HTTP. 
LICENSE  = GPLv2

ENV += HOSTCC=gcc HOSTCFLAGS=
GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = darkstat_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: darkstat_pre_configure
darkstat_pre_configure:
	@$(RUN) autoconf
	@$(RUN) autoheader

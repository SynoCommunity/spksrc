ARCH ?= wdarmv5
TCVERSION ?= 2.12
PKG_NAME = wdarmv5
PKG_ARCH = $(PKG_NAME)
PKG_EXT = tar.gz
PKG_DIST_NAME = linux-3.2.40.$(PKG_EXT)
PKG_DIST_SITE = https://dl.bintray.com/tfl/wdpksrc
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_EXTRACT = linux-3.2.40
SYNO_CONFIG = synoconfigs/$(PKG_ARCH)
BASE_ARCH = arm

HOMEPAGE = http://www.wd.com/

include ../../mk/spksrc.kernel-modules.mk

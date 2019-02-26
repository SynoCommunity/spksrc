ARCH ?= wdarm
TCVERSION ?= 6.1
PKG_NAME = wdarm
PKG_ARCH = $(PKG_NAME)
PKG_EXT = tar.gz
PKG_DIST_NAME = linux-3.10.39-2014_T3.0.$(PKG_EXT)
PKG_DIST_SITE = https://dl.bintray.com/tfl/wdpksrc
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_EXTRACT = linux-3.10.39-2014_T3.0
SYNO_CONFIG = synoconfigs/$(PKG_ARCH)
BASE_ARCH = arm

HOMEPAGE = http://www.wd.com/

include ../../mk/spksrc.kernel-modules.mk

ARCH ?= geminilake
TCVERSION ?= 6.2.2
PKG_NAME = geminilake
PKG_BRANCH = 24922
PKG_ARCH = $(PKG_NAME)
PKG_EXT = txz
PKG_DIST_NAME = linux-4.4.x-glk.$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch/$(PKG_ARCH)-source
PKG_DIST_FILE = $(PKG_NAME)-linux-4.4.x.$(PKG_EXT)
PKG_EXTRACT = linux-4.4.x-glk
SYNO_CONFIG = synoconfigs/$(ARCH)
BASE_ARCH = x86

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

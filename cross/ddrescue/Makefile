PKG_NAME = ddrescue
PKG_VERS = 1.26
PKG_EXT = tar.lz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/ddrescue
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/ddrescue/
COMMENT = GNU ddrescue is a data recovery tool. It copies data from one file or block device (hard disc, cdrom, etc) to another, trying hard to rescue data in case of read errors.
LICENSE = GPLv2/GPLv3

ADDITIONAL_CXXFLAGS = -Wall -W -O

include ../../mk/spksrc.cross-cc.mk

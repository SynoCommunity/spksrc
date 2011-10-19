
PKG_NAME = par2cmdline
PKG_VERS = 0.4
PKG_EXT = tar.gz
PKG_REV = 1
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/parchive/files/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

MAINTAINER=	superzebulon@superzebulon.org
HOMEPAGE=	http://parchive.sourceforge.net/
COMMENT=	Data-recovery tool for the posting & recovery of multi-part archives on Usenet
LICENSE=	GPL

GNU_CONFIGURE = 1

PATCH_TARGET = myPatch

include ../../mk/spksrc.cross-cc.mk

myPatch:
	@gzip -dc patches/par2cmdline_0.4-11.diff.gz | ($(RUN) patch -p1)
	@$(RUN) tail -n +48 debian/patches/000_unidentified.diff | patch
	@$(RUN) cat debian/patches/002-gcc_40_fixes.patch | patch
	@$(RUN) cat debian/patches/003_fix_crash_in_quiet_mode.patch | patch
	
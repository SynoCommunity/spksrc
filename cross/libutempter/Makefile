PKG_NAME = libutempter
PKG_VERS = 1.1.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.altlinux.org/pub/people/ldv/utempter/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

CONFIGURE_TARGET = nop
DEPENDS =

POST_PATCH_TARGET = libutempter_post_patch

HOMEPAGE = http://freshmeat.sourceforge.net/projects/libutempter
COMMENT  = libutempter provides a library interface for terminal emulators such as screen and xterm to record user sessions to utmp and wtmp files.
LICENSE  = LGPLv2

include ../../mk/spksrc.cross-cc.mk

.PHONY: libutempter_post_patch
libutempter_post_patch:
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(STAGING_INSTALL_PREFIX)#' -i Makefile


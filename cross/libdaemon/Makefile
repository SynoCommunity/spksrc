PKG_NAME = libdaemon
PKG_VERS = 0.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://0pointer.de/lennart/projects/$(PKG_NAME)
# 0pointer.de is unreachable from CI; fall back to the Gentoo mirror. Subdir = first
# two hex of blake2b of the file name (recompute on a version bump).
PKG_DIST_MIRRORS = https://distfiles.gentoo.org/distfiles/66
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://0pointer.de/lennart/projects/libdaemon/
COMMENT  = libdaemon is a lightweight C library that eases the writing of UNIX daemons.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_func_setpgrp_void=yes

include ../../mk/spksrc.cross-cc.mk

PKG_NAME = libdaemon
PKG_VERS = 0.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://0pointer.de/lennart/projects/$(PKG_NAME)
# 0pointer.de is upstream but unreachable from CI (IPv6 "network unreachable", then
# IPv4 "connection refused") and serves only over plain http. Gentoo mirrors the same
# tarball under its upstream name, so fall back there. The subdirectory is the first
# two hex digits of the blake2b hash of the file name, so it must be recomputed on a
# version bump; a stale one just 404s and we fall through. A mirror base is only ever
# appended with PKG_DIST_NAME. Debian cannot be used: it renames the file to
# libdaemon_$(PKG_VERS).orig.tar.gz.
PKG_DIST_MIRRORS = https://distfiles.gentoo.org/distfiles/66
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://0pointer.de/lennart/projects/libdaemon/
COMMENT  = libdaemon is a lightweight C library that eases the writing of UNIX daemons.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_func_setpgrp_void=yes

include ../../mk/spksrc.cross-cc.mk

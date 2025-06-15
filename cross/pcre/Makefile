PKG_NAME = pcre
PKG_VERS = 8.45
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://altushost-swe.dl.sourceforge.net/project/pcre/pcre/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# This version of PCRE is now at end of life, and is no longer being actively maintained. 
# Version 8.45 is expected to be the final release of the older PCRE library, and new projects should use PCRE2 instead.
# 
# Dependent packages should be migrated to use cross/pcre2

DEPENDS =

HOMEPAGE = https://www.pcre.org
COMMENT  = The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.
LICENSE  = BSD

GNU_CONFIGURE = 1
# enable UTF-8 support
# pcre is used by glib-2.58 and dependents: mc, sshfs2, irssi, rmlint
CONFIGURE_ARGS = --enable-utf
CONFIGURE_ARGS += --enable-unicode-properties
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk

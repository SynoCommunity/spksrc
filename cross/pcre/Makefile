PKG_NAME = pcre
PKG_VERS = 8.41
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.pcre.org/pub/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.pcre.org
COMMENT  = The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.
LICENSE  = BSD

GNU_CONFIGURE = 1
# enable UTF-8 support
# pcre is used by: mc, sshfs, irssi, bitlbee, museek-plus
CONFIGURE_ARGS = --enable-utf --enable-unicode-properties

include ../../mk/spksrc.cross-cc.mk

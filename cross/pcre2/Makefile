PKG_NAME = pcre2
PKG_VERS = 10.44
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/PhilipHazel/pcre2/releases/download/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =
OPTIONAL_DEPENDS = cross/readline cross/zlib cross/bzip2

CONFIGURE_ARGS  = --enable-pcre2-32
CONFIGURE_ARGS += --disable-static

ifeq ($(strip $(PCRE2_CLI_FULL)),1)
# add additional features to pcre2grep and pcre2test
DEPENDS += cross/readline cross/zlib cross/bzip2
CONFIGURE_ARGS += --enable-jit
CONFIGURE_ARGS += --enable-pcre2-16
CONFIGURE_ARGS += --enable-pcre2grep-libz
CONFIGURE_ARGS += --enable-pcre2grep-libbz2
CONFIGURE_ARGS += --enable-pcre2grep-callout 
CONFIGURE_ARGS += --enable-pcre2test-libreadline
else
PLIST_TRANSFORM = sed -e '/:lib\/libpcre2-16/d'
endif

HOMEPAGE = https://www.pcre.org
COMMENT  = The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.
LICENSE  = BSD

GNU_CONFIGURE = 1

ADDITIONAL_CPPFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk

PKG_NAME = pcre2
PKG_VERS = 10.46
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
CONFIGURE_ARGS += --enable-pcre2-16
CONFIGURE_ARGS += --enable-pcre2grep-libz
CONFIGURE_ARGS += --enable-pcre2grep-libbz2
CONFIGURE_ARGS += --enable-pcre2grep-callout 
CONFIGURE_ARGS += --enable-pcre2test-libreadline

CONFIGURE_ARGS += --enable-jit
include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ifeq ($(call version_lt, $(TC_GCC), 5),1)
# asm in jit code (for 32-bit x86) does not work with gcc < 5.0 when position independent code (aka PIC) is created.
# src/../deps/sljit/sljit_src/sljitNativeX86_common.c:462:2: error: inconsistent operand constraints in an 'asm'
# Disable position independent code:
CONFIGURE_ARGS += --without-pic
endif
endif

else
# regular build
PLIST_TRANSFORM = sed -e '/:lib\/libpcre2-16/d'
endif

HOMEPAGE = https://www.pcre.org
COMMENT  = The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.
LICENSE  = BSD

GNU_CONFIGURE = 1

ADDITIONAL_CPPFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk

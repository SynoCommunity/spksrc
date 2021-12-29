PKG_NAME = emacs
PKG_VERS = 27.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/gnutls cross/ncursesw

HOMEPAGE = https://www.gnu.org/software/emacs/
COMMENT  = Emacs is the extensible, customizable, self-documenting real-time display editor.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

#PRE_COMPILE_TARGET = emacs_pre_compile

CONFIGURE_ARGS  = --with-gnutls
CONFIGURE_ARGS += --without-x --without-x-toolkit
CONFIGURE_ARGS += --without-xpm --without-jpeg --without-png --without-gif --without-tiff

include ../../mk/spksrc.cross-cc.mk

.PHONY: emacs_pre_compile
emacs_pre_compile:
	# TODO: build "make make-docfile" and "make make-fingerprint" tools for host system
	#       i.e. these tools must be executed on intel host cpu at build time.
	$(RUN) ; cd $(WORK_DIR)/lib-src/

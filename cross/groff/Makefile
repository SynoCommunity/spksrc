PKG_NAME = groff
PKG_VERS = 1.22.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/urw-base35-fonts cross/uchardet
BUILD_DEPENDS = native/ghostscript 

HOMEPAGE = https://www.gnu.org/software/groff/
COMMENT  = Groff \(GNU troff\) is a typesetting system that reads plain text mixed with formatting commands and produces formatted output. Output may be PostScript or PDF, html, or ASCII/UTF8 for display at the terminal. Formatting commands may be either low-level typesetting requests \(\"primitives\"\) or macros from a supplied set. Users may also write their own macros. All three may be combined.
LICENSE  = GNU GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-doc --with-urw-fonts-dir=$(STAGING_INSTALL_PREFIX)/share/fonts

ENV += PATH=$(WORK_DIR)/../../../native/ghostscript/work-native/install/usr/local/bin/:$$PATH 


include ../../mk/spksrc.cross-cc.mk

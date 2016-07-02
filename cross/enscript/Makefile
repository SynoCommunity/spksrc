PKG_NAME = enscript
PKG_VERS = 1.6.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/enscript/
COMMENT  = GNU Enscript converts ASCII files to PostScript, HTML, or RTF and stores generated output to a file or sends it directly to the printer.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk

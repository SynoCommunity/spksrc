PKG_NAME = file
PKG_VERS = 5.46
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.astron.com/pub/file
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.darwinsys.com/file/
COMMENT  = The file command is "a file type guesser", that is, a command-line tool that tells you in words what kind of data a file contains. Unlike most GUI systems, command-line UNIX systems - with this program leading the charge - don't rely on filename extentions to tell you the type of a file, but look at the file's actual contents. This is, of course, more reliable, but requires a bit of I/O.
LICENSE  = https://github.com/file/file/blob/master/COPYING

GNU_CONFIGURE = 1
# force build of static version
# otherwise magic.mgc fails to build with error:
# Compiled magic version [546] does not match with shared library magic version [544]
CONFIGURE_ARGS += --enable-static --disable-shared

include ../../mk/spksrc.native-cc.mk

PKG_NAME = file
PKG_VERS = 5.35
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.astron.com/pub/file/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# remarks: the build environment must have file installed of the same version

DEPENDS =

HOMEPAGE = https://www.darwinsys.com/file/
COMMENT  = The file command is "a file type guesser", that is, a command-line tool that tells you in words what kind of data a file contains. Unlike most GUI systems, command-line UNIX systems - with this program leading the charge - don't rely on filename extentions to tell you the type of a file, but look at the file's actual contents. This is, of course, more reliable, but requires a bit of I/O.
LICENSE  = https://github.com/file/file/blob/master/COPYING

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

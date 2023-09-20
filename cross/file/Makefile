PKG_NAME = file
PKG_VERS = 5.45
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.astron.com/pub/file
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/file

HOMEPAGE = https://www.darwinsys.com/file/
COMMENT  = The file command is "a file type guesser", that is, a command-line tool that tells you in words what kind of data a file contains. Unlike most GUI systems, command-line UNIX systems - with this program leading the charge - don't rely on filename extentions to tell you the type of a file, but look at the file's actual contents. This is, of course, more reliable, but requires a bit of I/O.
LICENSE  = https://github.com/file/file/blob/master/COPYING

GNU_CONFIGURE = 1

ADDITIONAL_CPPFLAGS = -Os

#COMPILE_TARGET = file_compile

# 
# file -m /spksrc/native/file/work-native/install/usr/local/share/misc/magic.mgc -C -m magic



#BIN_PATH = $(abspath $(WORK_DIR)/../../../native/file/work-native/install/usr/local/bin)
#ENV += PATH:=$(BIN_PATH):$(PATH)
#MAGIC_FILE = $(abspath $(WORK_DIR)/../../../native/file/work-native/install/usr/local/share/misc/magic.mgc)
#ENV += NATIVE_MAGIC=$(MAGIC_FILE)

#NATIVE_FILE = $(BIN_PATH)/file
NATIVE_FILE = $(abspath $(WORK_DIR)/../../../native/file/work-native/install/usr/local/bin/file)
ENV += NATIVE_FILE=$(NATIVE_FILE)
#export PATH:=$(BIN_PATH):$(PATH)

#COMPILE_MAKE_OPTIONS = MAGIC=$(MAGIC_FILE)

include ../../mk/spksrc.cross-cc.mk


.PHONY: file_compile
file_compile:
	$(RUN) MAGIC=$(MAGIC_FILE) $(MAKE)


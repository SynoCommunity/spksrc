PKG_NAME = ncdc
PKG_VERS = 1.19.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://dev.yorhel.nl/download
SPK_REV = 1

DEPENDS = cross/ncursesw cross/zlib cross/glib cross/sqlite cross/gnutls cross/bzip2

HOMEPAGE = http://dev.yorhel.nl/ncdc
COMMENT  = Ncdc is a modern and lightweight direct connect client with a friendly ncurses interface.
LICENSE  = MIT

MAINTAINER = sirjeannot@gmail.com

GNU_CONFIGURE = 0
PRE_COMPILE_TARGET = myPreCompile

CONFIGURE_ARGS  =
ADDITIONAL_CFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreCompile
myPreCompile:
#       $(TC_PATH)$(TC_PREFIX)gcc $(WORK_DIR)/$(PKG_DIR)/deps/makeheaders.c -o $(WORK_DIR)/$(PKG_DIR)/makeheaders
        gcc $(WORK_DIR)/$(PKG_DIR)/deps/makeheaders.c -o $(WORK_DIR)/$(PKG_DIR)/makeheaders
        ln -s $(WORK_DIR)/$(PKG_DIR)/config.h $(WORK_DIR)/$(PKG_DIR)/doc/config.h
#       $(TC_PATH)$(TC_PREFIX)gcc -I. $(WORK_DIR)/$(PKG_DIR)/doc/gendoc.c -o $(WORK_DIR)/$(PKG_DIR)/gendoc
        gcc -I. $(WORK_DIR)/$(PKG_DIR)/doc/gendoc.c -o $(WORK_DIR)/$(PKG_DIR)/gendoc



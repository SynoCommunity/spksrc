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

GNU_CONFIGURE = 1
PRE_COMPILE_TARGET = myPreCompile

CONFIGURE_ARGS  =  
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreCompile
myPreCompile:
	ln -s $(WORK_DIR)/$(PKG_DIR)/config.h $(WORK_DIR)/$(PKG_DIR)/doc/config.h
	cc $(WORK_DIR)/$(PKG_DIR)/deps/makeheaders.c -o $(WORK_DIR)/$(PKG_DIR)/makeheaders
	cc -I. $(WORK_DIR)/$(PKG_DIR)/doc/gendoc.c -o $(WORK_DIR)/$(PKG_DIR)/gendoc
	patch $(WORK_DIR)/$(PKG_DIR)/Makefile < patch

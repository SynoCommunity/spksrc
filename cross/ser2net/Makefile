PKG_NAME = ser2net
PKG_VERS = 4.0
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE =  http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)

DEPENDS = cross/gensio cross/libyaml

HOMEPAGE = https://sourceforge.net/projects/ser2net/
COMMENT  = Serial port to network proxy
LICENSE  = GPLv2

GNU_CONFIGURE = 1
#PRE_CONFIGURE_TARGET = myPreConfigure
#PATCHES_LEVEL = 1

#CONFIGURE_ARGS  = --with-pty-mode=0620 --with-pty-group=5
#TODO: Do like in OE, put this in the toolchain configuration file
#CONFIGURE_ARGS += screen_cv_sys_bcopy_overlap=no screen_cv_sys_memcpy_overlap=no screen_cv_sys_memmove_overlap=no screen_cv_sys_fifo_broken_impl=no
#CONFIGURE_ARGS += screen_cv_sys_fifo_usable=yes screen_cv_sys_select_broken_retval=no screen_cv_sys_sockets_nofs=no screen_cv_sys_sockets_usable=yes
#CONFIGURE_ARGS += screen_cv_sys_terminfo_used=yes

include ../../mk/spksrc.cross-cc.mk

#.PHONY: myPreConfigure
#myPreConfigure:
#	$(RUN) autoconf

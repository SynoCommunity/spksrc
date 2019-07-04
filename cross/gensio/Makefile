PKG_NAME = gensio
PKG_VERS = 1.0
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE = https://github.com/cminyard/$(PKG_NAME)/archive
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)

HOMEPAGE = https://sourceforge.net/projects/ser2net/
COMMENT  = gensio - General Stream I/O
LICENSE  = GPLv2

DEPENDS = cross/openssl

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure
#PATCHES_LEVEL = 1

CONFIGURE_ARGS  = --with-python=no --with-swig=no
#TODO: Do like in OE, put this in the toolchain configuration file
#CONFIGURE_ARGS += screen_cv_sys_bcopy_overlap=no screen_cv_sys_memcpy_overlap=no screen_cv_sys_memmove_overlap=no screen_cv_sys_fifo_broken_impl=no
#CONFIGURE_ARGS += screen_cv_sys_fifo_usable=yes screen_cv_sys_select_broken_retval=no screen_cv_sys_sockets_nofs=no screen_cv_sys_sockets_usable=yes
#CONFIGURE_ARGS += screen_cv_sys_terminfo_used=yes

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf -i 
	# autoconf

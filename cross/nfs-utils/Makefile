PKG_NAME_MAIN = nfs
PKG_NAME = $(PKG_NAME_MAIN)-utils
PKG_VERS = 1.3.3
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/$(PKG_NAME_MAIN)/files

DEPENDS = cross/libtool cross/util-linux cross/libtirpc cross/libwrap cross/libevent cross/sqlite cross/libnfsidmap

HOMEPAGE = http://nfs.sourceforge.net/
COMMENT  = Userspace server and client tools necessary to use the kernel\'s NFS abilities
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --disable-nfsv4 --disable-gss --without-tcp-wrappers
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(STAGING_INSTALL_PREFIX)

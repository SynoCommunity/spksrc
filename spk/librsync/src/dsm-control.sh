PKG_NAME = librsync
PKG_VERS = 0.9.7
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/librsync/$(PKG_NAME)/$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://librsync.sourceforge.net/
COMMENT  = librsync is a free software library that implements the rsync remote-delta algorithm
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared

include ../../mk/spksrc.cross-cc.mk
root@debian-x86:~/backup/spksrc/spk/librsync# cd src/
root@debian-x86:~/backup/spksrc/spk/librsync/src# ls
dsm-control.sh  installer.sh  librsync.png
root@debian-x86:~/backup/spksrc/spk/librsync/src# cat dsm-control.sh
#!/bin/sh

# Package
PACKAGE="librsync"
DNAME="librsync"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"


case $1 in
    start)
        exit 0
        ;;
    stop)
        exit 0
        ;;
    status)
        exit 1
        ;;
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac

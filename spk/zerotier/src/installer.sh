#!/bin/sh

PACKAGE="zerotier"
DNAME="ZeroTier"
INSTALL_DIR="/usr/local/${PACKAGE}"
ZT_HOMEDIR="${SYNOPKG_PKGDEST}/var"

preinst ()
{
    exit 0
}

postinst ()
{
    # make installation and config dirs
    mkdir -p ${INSTALL_DIR}/bin
    mkdir -p ${ZT_HOMEDIR}
    # remove old device map file if it exists
    rm -rf ${ZT_HOMEDIR}/devicemap
    # link to binaries
    chmod 755 ${SYNOPKG_PKGDEST}/bin/zerotier-one
    #chmod 755 ${SYNOPKG_PKGDEST}/bin/start-stop-status
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    ln -s ${SYNOPKG_PKGDEST}/bin/zerotier-one /usr/local/bin/zerotier-cli
    ln -s ${SYNOPKG_PKGDEST}/bin/zerotier-one /usr/local/bin/zerotier-idtool
    # nginx proxy config
    cp -f ${SYNOPKG_PKGDEST}/ui/dsm.zerotier.conf /usr/local/etc/nginx/conf.d/dsm.zerotier.conf
    # for nginx to reload new reverse proxy conf file
    nginx -s reload
    # load TUN kernel module
    SERVICE="zerotier"
    ZEROTIER_MODULE="tun.ko"
    BIN_SYNOMODULETOOL="/usr/syno/bin/synomoduletool"

    # Make device if not present (not devfs)
    if ( [ ! -c /dev/net/tun ] ) then
            # Make /dev/net directory if needed
            if ( [ ! -d /dev/net ] ) then
                mkdir -m 755 /dev/net
            fi
            mknod /dev/net/tun c 10 200
    fi
    # Load TUN kernel module
    if [ -x ${BIN_SYNOMODULETOOL} ]; then
        $BIN_SYNOMODULETOOL --insmod $SERVICE ${ZEROTIER_MODULE}
    else
        /sbin/insmod /lib/modules/${ZEROTIER_MODULE}
    fi
    exit 0
}

preuninst ()
{
    killall -s SIGKILL zerotier-one;
    # remove all files except for identity files and network config files (for future convenience)
    find ${ZT_HOMEDIR} -type f ! -name 'identity.*' -delete
    rm -rf ${ZT_HOMEDIR}/peers.d ${ZT_HOMEDIR}/controller.d ${ZT_HOMEDIR}/iddb.d /usr/local/bin/zerotier-cli /usr/local/bin/zerotier-idtool
    # nginx de-config
    rm -f /usr/local/etc/nginx/conf.d/dsm.zerotier.conf
    rm -f /etc/init.d/zerotier
    exit 0
}

postuninst ()
{
    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
}

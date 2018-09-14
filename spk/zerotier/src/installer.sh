#!/bin/sh

# Package
PACKAGE="zerotier"
DNAME="ZeroTier"

# Others
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

INSTALL_DIR="/usr/local/${PACKAGE}"
ZT_HOMEDIR="/var/lib/zerotier-one"
LOG_FILE="/var/log/zerotier-one.log"

INSTALL_DIR="/usr/local/${PACKAGE}"
LOG_FILE="/var/log/zerotier-one.log"

preinst ()
{
    exit 0
}

postinst ()
{
    echo "$(date) INSTALL: Unpacked to: " ${SYNOPKG_PKGDEST} >> ${LOG_FILE} ;
    echo "$(date) INSTALL: INSTALL_DIR=" ${INSTALL_DIR} >> ${LOG_FILE} ;

    # make installation and config dirs
    mkdir -p ${INSTALL_DIR}/bin
    mkdir -p /var/lib/zerotier-one
    # remove old device map file if it exists
    rm -rf {INSTALL_DIR}/devicemap
    # link to binaries
    echo "$(date) INSTALL: creating symlinks from ${SYNOPKG_PKGDEST} to ${INSTALL_DIR} and ${INSTALL_DIR}/bin" >> ${LOG_FILE} ;
    chmod 755 ${SYNOPKG_PKGDEST}/bin/zerotier-one
    chmod 755 ${SYNOPKG_PKGDEST}/bin/start-stop-status
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    ln -s ${SYNOPKG_PKGDEST}/bin/zerotier-one /usr/local/bin/zerotier-cli
    ln -s ${SYNOPKG_PKGDEST}/bin/zerotier-one /usr/local/bin/zerotier-idtool
    # install control script

    # nginx proxy config
    echo "$(date) INSTALL: setting nginx reverse proxy config" >> ${LOG_FILE} ;
    cp -f ${SYNOPKG_PKGDEST}/ui/dsm.zerotier.conf /usr/local/etc/nginx/conf.d/dsm.zerotier.conf
    # for nginx to reload new reverse proxy conf file
    nginx -s reload

    # load TUN kernel module
    SERVICE="zerotier"
    ZEROTIER_MODULE="tun.ko"
    BIN_SYNOMODULETOOL="/usr/syno/bin/synomoduletool"

    # Make device if not present (not devfs)
    echo "$(date) INSTALL: creating /dev/net/tun device" >> ${LOG_FILE} ;
    if ( [ ! -c /dev/net/tun ] ) then
            # Make /dev/net directory if needed
            if ( [ ! -d /dev/net ] ) then
                mkdir -m 755 /dev/net
            fi
            mknod /dev/net/tun c 10 200
    fi

    # Load TUN kernel module
    echo "$(date) INSTALL: loading TUN kernel module" >> ${LOG_FILE} ;
    if [ -x ${BIN_SYNOMODULETOOL} ]; then
        $BIN_SYNOMODULETOOL --insmod $SERVICE ${ZEROTIER_MODULE}
    else
        /sbin/insmod /lib/modules/${ZEROTIER_MODULE}
    fi
    exit 0
}

preuninst ()
{
    echo "$(date) UNINSTALL: killing zerotier-one and watchdog" >> ${LOG_FILE} ;
    killall zerotier-one ;
    pkill -f "zerotier-watchdog" ;
    echo "$(date) UNINSTALL: removing config files but leaving identity.* files" >> ${LOG_FILE} ;
    # remove all files except for identity files and network config files (for future convenience)
    find ${ZT_HOMEDIR} -type f ! -name 'identity.*' -delete
    rm -rf ${INSTALL_DIR} ${ZT_HOMEDIR}/peers.d ${ZT_HOMEDIR}/controller.d ${ZT_HOMEDIR}/iddb.d /usr/local/bin/zerotier-cli /usr/local/bin/zerotier-idtool
    # nginx de-config
    echo "$(date) UNINSTALL: removing nginx reverse proxy config" >> ${LOG_FILE} ;
    rm -f /usr/local/etc/nginx/conf.d/dsm.zerotier.conf
    rm -f /etc/init.d/zerotier
    # TODO: check devicemap and remove all ls /etc/sysconfig/network-scripts entries
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

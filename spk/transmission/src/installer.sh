#!/bin/sh

#Set PATH to avoid ipkg stuff
PATH=/bin:/usr/bin:/usr/syno/sbin

INSTALL_PREFIX=/usr/local/transmission

preinst ()
{
    exit 0
}

postinst ()
{
    # Create the transmission user if needed
    if synouser --enum local | grep ^transmission$ >/dev/null
    then
        true # the user exists, nothing to do
    else
        synouser --add transmission `${SYNOPKG_PKGDEST}/sbin/passgen 1 12` 'Transmission User' '' '' ''
    fi

    # Installation directory
    mkdir -p ${INSTALL_PREFIX}
    mkdir -p /usr/local/bin

    # Extract the files to the installation ditectory
    ${SYNOPKG_PKGDEST}/sbin/xzdec -c ${SYNOPKG_PKGDEST}/package.txz | \
        tar xpf - -C ${INSTALL_PREFIX}
    # Remove the installer archive to save space
    rm ${SYNOPKG_PKGDEST}/package.txz

    # Create symlinks to utils
    for bin in transmission-create transmission-edit transmission-remote transmission-show
    do
      ln -s ${INSTALL_PREFIX}/bin/$bin /usr/local/bin/$bin
    done

    # Install the application in the main interface.
    if [ -d $SYNO3APP ]
    then
        rm -f $SYNO3APP/transmission
        ln -s ${INSTALL_PREFIX}/share/synoman $SYNO3APP/transmission
    fi

    # Complete the configuration file
    # /usr/local/etc/rc.d/transmission.sh is still not available
    /var/packages/transmission/scripts/start-stop-status settings

    # Correct the files ownership    
    chown -R transmission:users ${INSTALL_PREFIX} ${SYNOPKG_PKGDEST}/var
    
    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove the application from the main interface if it was previously added.
    if [ -h $SYNO3APP/transmission ]
    then
        rm $SYNO3APP/transmission
    fi

    # Remove symlinks to utils
    for bin in transmission-create transmission-edit transmission-remote transmission-show
    do
      rm /usr/local/bin/$bin
    done

    # Remove the installation directory
    rm -fr ${INSTALL_PREFIX}

    if [ -f $isUpgrade ]
    then
        true # Keep the transmission user, as we are upgrading
    else
        # Remove the user
        synouser --del transmission 2> /dev/null
    fi

    exit 0
}

preupgrade ()
{
    # Make sure transmission is not running while we are upgrading
    /usr/local/etc/rc.d/transmission.sh stop
    touch $isUpgrade

    # Save current state before upgrade
    upgradedir=/`echo ${SYNOPKG_PKGDEST} | cut -d/ -f2`/@tmp/transmission-upgrade/
    mkdir -p $upgradedir
    if [ -d ${SYNOPKG_PKGDEST}/usr ]
    then
        # Old installation scheme
        cp -r ${SYNOPKG_PKGDEST}/usr/local/var/lib/transmission-daemon $upgradedir/var
    else
        if [ -d ${SYNOPKG_PKGDEST}/var ]
        then
            # New installation scheme
            cp -r ${SYNOPKG_PKGDEST}/var $upgradedir/var
        fi
    fi
    exit 0
}

postupgrade ()
{
    # Restore state
    upgradedir=/`echo ${SYNOPKG_PKGDEST} | cut -d/ -f2`/@tmp/transmission-upgrade/
    if [ -d $upgradedir/var ]
    then
        cp -r $upgradedir/var ${SYNOPKG_PKGDEST}/
        chown -R transmission:users ${SYNOPKG_PKGDEST}/var
    fi

    # Correct permission and ownership of download directory
    downloadDir=`grep download-dir ${SYNOPKG_PKGDEST}/var/settings.json | cut -d'"' -f4`
    if [ -n "$downloadDir" -a -d "$downloadDir" ]
    then
        chown -R transmission:users $downloadDir
        chmod -R g+w $downloadDir
    fi

    # Correct permission and ownership of incomplete directory
    incompleteDir=`grep incomplete-dir ${SYNOPKG_PKGDEST}/var/settings.json | cut -d'"' -f4`
    if [ -n "$incompleteDir" -a -d "$incompleteDir" ]
    then
        chown -R transmission:users $incompleteDir
    fi

    rm -fr $upgradedir
    rm -f $isUpgrade

    exit 0
}

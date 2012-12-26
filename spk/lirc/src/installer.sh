#!/bin/sh

# Package
PACKAGE="lirc"
DNAME="LIRC"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    # Installation wizard requirements
#    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ] && [ ! -d "${wizard_download_dir}" ]; then
#        exit 1
#    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create device and socket
    test -e /dev/lirc || /bin/mknod /dev/lirc c 61 0
    mkdir -p /var/run/lirc
    touch /var/run/lirc/lircd
    chmod -R 666 /var/run/lirc/lircd

    # Put the config file in place??

    # Fix PATH to include package binaries
    fixpath

    # Set up the driver module selected during wizard installation
    for DRIVER in `ls ${INSTALL_DIR}/lib/modules | grep -v lirc_dev.ko | awk -F'_' '{print \$2}' | awk -F'.' '{print \$1}'`; do 
        #echo $${DRIVER}
        if [ "$(eval echo \$lirc_driver_${DRIVER})" = "true" ]; then
            sed -i "s/@driver@/${DRIVER}/g" ${SSS}
            sed -i "s/#insmod/insmod/g" ${SSS}
            sed -i "s/#rmmod/rmmod/g" ${SSS}
            break
        fi
    done


    # Edit the configuration according to the wizard
#    sed -i -e "s|@download_dir@|${wizard_download_dir}|g" ${CFG_FILE}
#    if [ -d "${wizard_watch_dir}" ]; then
#        sed -i -e "s|@watch_dir_enabled@|true|g" ${CFG_FILE}
#        sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${CFG_FILE}
#    else
#        sed -i -e "s|@watch_dir_enabled@|false|g" ${CFG_FILE}
#        sed -i -e "/@watch_dir@/d" ${CFG_FILE}
#    fi


    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Delete the device and socket
    test -c /dev/lirc && rm /dev/lirc
    rm -rf /var/run/lirc
    

    # Remove the user (if not upgrading)
#    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
#        delgroup ${USER} ${GROUP}
#        deluser ${USER}
#    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
#    rm -fr ${TMP_DIR}/${PACKAGE}
#    mkdir -p ${TMP_DIR}/${PACKAGE}
#    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
#    rm -fr ${INSTALL_DIR}/var
#    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
#    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}

fixpath ()
{
    # fix roots .profile
    if [ $(grep "\${PATH}" /root/.profile | wc -l) -eq 0 ]; then
        #sed -i 's/PATH=/PATH=\${PATH}:/' /root/.profile
        echo fixing roots .profile
    fi

    # fix the global /etc/profile
    if [ $(grep "\$pack" /etc/profile | wc -l) -eq 0 ]; then
        #sed -i 's,export PATH,for pack in \$\(ls /var/packages\)\; do\n    PATH=\$\{PATH\}:/var/packages/\$pack/target/bin:/var/packages/\$pack/target/sbin\ndone\nexport PATH,' /etc/profile
        echo fixing etc/profile
    fi
}

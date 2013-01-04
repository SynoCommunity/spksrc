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
    chmod -R 666 /var/run/lirc

    # Fix PATH to include package binaries
    fixpath

    # Set up the driver module(s) selected during installation wizard
    if [ "${lirc_driver_selected}" = "all" ]; then
        sed -i "s/#load_unload_drivers/load_unload_drivers/g" ${SSS}
    else
        for DRIVER in `ls ${INSTALL_DIR}/lib/modules | grep -v lirc_dev.ko | awk -F'_' '{print \$2}' | awk -F'.' '{print \$1}'`; do 
            if [ "${lirc_driver_selected}" = "${DRIVER}" ]; then
                sed -i "s/@driver@/${DRIVER}/g" ${SSS}
                sed -i "s/#insmod/insmod/g" ${SSS}
                sed -i "s/#rmmod/rmmod/g" ${SSS}
                break
            fi
        done
    fi

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Delete the device and socket
    test -c /dev/lirc && rm /dev/lirc
    rm -rf /var/run/lirc
    
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
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    cd ${INSTALL_DIR} && tar cpf ${TMP_DIR}/${PACKAGE}/conf_backup.tar etc 

    exit 0
}

postupgrade ()
{
    # Restore some stuff
     cd ${INSTALL_DIR} && find etc -type f -print | grep -v -e "^etc/lirc/lircd.conf$" -e "^etc/lirc/lircrc$" > ${TMP_DIR}/${PACKAGE}/exclude
     cd ${INSTALL_DIR} && tar xpf ${TMP_DIR}/${PACKAGE}/conf_backup.tar -X ${TMP_DIR}/${PACKAGE}/exclude

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

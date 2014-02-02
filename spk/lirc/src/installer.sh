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

    # Fix PATH to include package binaries
    fixpath

    # If variable is empty, see if this is an upgrade and grab the saved driver
    if [[ -z ${lirc_driver_selected} ]]; then
        lirc_driver_selected=$(cat ${TMP_DIR}/${PACKAGE}/driver 2>/dev/null || echo none)
    fi

    # Set up the driver module selected during installation wizard
    case ${lirc_driver_selected} in
        mceusb)
            sed -i "s/@driver@/${lirc_driver_selected}/g" ${SSS}
    
            # Create driver-specific device
            test -e /dev/lirc || /bin/mknod /dev/lirc c 61 0
        ;;
        uirt|uirt2)
            sed -i "s/@driver@/${lirc_driver_selected}/g" ${SSS}

            # Create driver-specific device
            test -e /dev/usb/ttyUSB0 || mknod /dev/usb/ttyUSB0 c 188 0
        ;;
        *)
            # Driver not supported/tested, so we won't do anything here yet other than cleanup SSS
            sed -i "s/@driver@/none/g" ${SSS}
        ;;
    esac

    # Create socket for all drivers
    mkdir -p /var/run/lirc
    touch /var/run/lirc/lircd
    chmod -R 777 /var/run/lirc

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Identify the driver last used (in case of users having customised)
    LIRC_SELECTED_DRIVER=$(${SSS} driver)

    # TODO some driver-specific cleanup stuff here.....

    # Delete the device and socket if they exist regardless of driver
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

    # Setup a clean backup dir
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}

    # Save config and scripts
    cd ${INSTALL_DIR} && tar cpf ${TMP_DIR}/${PACKAGE}/conf_backup.tar etc 

    # Save selected driver
    echo $(${SSS} driver) > ${TMP_DIR}/${PACKAGE}/driver

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

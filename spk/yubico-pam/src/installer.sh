#!/bin/sh

# Package
PACKAGE="yubico-pam"
DNAME="yubico-pam"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"

# Binarys of the Package
BINARYS="modhex ykgenerate ykparse ykchalresp ykinfo ykpersonalize ykchalresp ykclient ykpamcfg ykhelper.sh"

# Libs of the Package
LIBS="libykclient.so libykpers-1.so libyubikey.so libusb-1.0.so"

# A secure path wich AppArmor allows for "authentification"-Profile
SECURE_AA_PATH_FOR_MAPS="/etc/security"


preinst ()
{
    exit 0
}

postinst ()
{   
    # Link the Package
    #ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    mkdir -p ${INSTALL_DIR}

    # Put binarys in the PATH
    mkdir -p /usr/local/bin
      
    for FILE in ${BINARYS} ; do
      cp -fP ${SYNOPKG_PKGDEST}/bin/${FILE} /usr/local/bin/${FILE}          
    done
    
    
    # Put libs in the PATH
    ln -s /lib ${INSTALL_DIR}/lib 
    
    for FILE in ${LIBS} ; do
      cp -fP ${SYNOPKG_PKGDEST}/lib/${FILE}* /lib       
    done
    
    cp -f ${SYNOPKG_PKGDEST}/lib/security/pam_yubico.so /lib/security/pam_yubico.so   
    
    
    # Put keymapping
    # The fu AppArmor only allows some dirs to access for login.cgi -> pam_yubico.so
    # One of this is /etc/security. So we symlink your path an put the mapfile there
    ln -sb ${SECURE_AA_PATH_FOR_MAPS} /etc/yubikey
       
    cp ${SYNOPKG_PKGDEST}/yubikey_mappings /etc/yubikey/yubikey_mappings
    
    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove bins
    for FILE in ${BINARYS} ; do
      rm -f /usr/local/bin/${FILE}
    done
    
    # Remove libs
    for FILE in ${LIBS} ; do
      rm -f /lib/${FILE}*          
    done
    
    rm -f /lib/security/pam_yubico.so 
    
    # Remove link for mapping-file but don't delete it
    rm -f /etc/yubikey 

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
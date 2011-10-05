#!/bin/sh

PATH=/bin:/usr/bin

# Find the CPU architecture
synoinfo=`get_key_value /etc.defaults/synoinfo.conf unique`
arch=`echo $synoinfo | cut -d_ -f2`
[ $arch = 88f6282 ] && arch=88f6281

preinst ()
{
    # Check if the architecture is supported
    case $arch in
        88f5281|88f6281|powerpc|ppc824x|ppc853x|ppc854x|x86)
            true
            ;;
        *)
            cat << EOM
Your architecture is not supported by this package, sorry.
Architecture  : $arch
Synology info : $synoinfo
EOM
        exit 1
            ;;
    esac

    exit 0
}

postinst ()
{
    # Installation directory
    mkdir -p /usr/local/python26

    # Extract the files to the installation ditectory
    ${SYNOPKG_PKGDEST}/sbin/xzdec-$arch -c ${SYNOPKG_PKGDEST}/package.txz | \
        tar xpf - -C /usr/local/python26 bin bin-$arch lib lib-$arch share
    # Remove the installer archive to save space
    rm ${SYNOPKG_PKGDEST}/package.txz

    # Merge the MD part in the MI part
    (
        cd /usr/local/python26
        for file in `(cd bin-$arch && find . \! -type d)`
        do
            mv bin-$arch/$file bin/$file
        done
        rm -fr bin-$arch
        for file in `(cd lib-$arch && find . \! -type d)`
        do
            mv lib-$arch/$file lib/$file
        done
        rm -fr lib-$arch
    )
    
    # Install xzdec for the companion tools installation
    cp ${SYNOPKG_PKGDEST}/sbin/xzdec-$arch /usr/local/python26/bin/xzdec 
    
    # Byte-compile the python distribution
    /usr/local/python26/bin/python -m compileall -q -f /usr/local/python26/lib/python2.6
    /usr/local/python26/bin/python -OO -m compileall -q -f /usr/local/python26/lib/python2.6

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove the installation directory
    rm -fr /usr/local/python26

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

#!/bin/sh

# Package
PACKAGE="ruby"
DNAME="Ruby"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/erb /usr/local/bin/erb
    ln -s ${INSTALL_DIR}/bin/gem /usr/local/bin/gem
    ln -s ${INSTALL_DIR}/bin/irb /usr/local/bin/irb
    ln -s ${INSTALL_DIR}/bin/rake /usr/local/bin/rake
    ln -s ${INSTALL_DIR}/bin/rdoc /usr/local/bin/rdoc
    ln -s ${INSTALL_DIR}/bin/ri /usr/local/bin/ri
    ln -s ${INSTALL_DIR}/bin/ruby /usr/local/bin/ruby

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

    rm -f /usr/local/bin/erb
    rm -f /usr/local/bin/gem
    rm -f /usr/local/bin/irb
    rm -f /usr/local/bin/rake
    rm -f /usr/local/bin/rdoc
    rm -f /usr/local/bin/ri
    rm -f /usr/local/bin/ruby

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

#!/bin/sh

# Package
PACKAGE="fish"
DNAME="fish"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"

preinst ()
{
  exit 0
}

postinst ()
{
  # Link
  ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

  # Put fish in the PATH
  mkdir -p /usr/local/bin
  ln -s ${INSTALL_DIR}/bin/fish /usr/local/bin/fish

  exit 0
}

preuninst ()
{
  exit 0
}

postuninst ()
{

  # Remove links
  rm -f /usr/local/bin/fish
  rm -f ${INSTALL_DIR}

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

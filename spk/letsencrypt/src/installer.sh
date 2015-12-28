#!/bin/sh

# Package
PACKAGE="letsencrypt"
DNAME="Lets Encrypt"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin:${PATH}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

	# Install synology compatible python-augeas module
	${INSTALL_DIR}/env/bin/pip install -r ${INSTALL_DIR}/share/python-augeas.req > /dev/null 2>&1
	
	# Install Letsencrypt & Letsencrypt-apache
	${INSTALL_DIR}/env/bin/pip install letsencrypt==0.1.1 > /dev/null 2>&1
	${INSTALL_DIR}/env/bin/pip install letsencrypt-apache==0.1.1 > /dev/null 2>&1
	
	
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

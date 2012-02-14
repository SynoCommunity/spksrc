#!/bin/sh

# Variables
PACKAGE="umurmur"
INSTALL_DIR="/usr/local/${PACKAGE}"
OPENSSL="${INSTALL_DIR}/bin/openssl"

# Certificate generation
${OPENSSL} req -x509 -newkey rsa:1024 -keyout ${INSTALL_DIR}/etc/umurmur.key -nodes -sha1 -days 365 -out ${INSTALL_DIR}/etc/umurmur.crt -batch -config ${INSTALL_DIR}/openssl.cnf > /dev/null 2>&1

# Exit with the right code and an explicit message
if [ $? -ne 0 ]; then
    echo "Certificate generation for uMurmur failed"
    touch ${INSTALL_DIR}/etc/umurmur.key
    touch ${INSTALL_DIR}/etc/umurmur.crt
    exit 1
fi

echo "uMurmur's certificate successfully generated"
exit 0

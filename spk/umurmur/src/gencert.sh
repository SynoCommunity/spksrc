#!/bin/sh

# Variables
PACKAGE="umurmur"
OPENSSL="${SYNOPKG_PKGDEST}/bin/openssl"

# Certificate generation
${OPENSSL} req -x509 -newkey rsa:1024 -keyout ${SYNOPKG_PKGDEST}/var/umurmur.key -nodes -sha1 -days 365 -out ${SYNOPKG_PKGDEST}/var/umurmur.crt -batch -config ${SYNOPKG_PKGDEST}/openssl.cnf > /dev/null 2>&1

# Exit with the right code and an explicit message
if [ $? -ne 0 ]; then
    echo "Certificate generation for uMurmur failed"
    touch ${SYNOPKG_PKGDEST}/var/umurmur.key
    touch ${SYNOPKG_PKGDEST}/var/umurmur.crt
    exit 1
fi

echo "uMurmur's certificate successfully generated"
exit 0

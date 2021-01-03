#!/bin/sh

# Variables
PACKAGE="umurmur"
OPENSSL="${SYNOPKG_PKGDEST}/bin/openssl"

# Certificate generation
${OPENSSL} req -x509 -newkey rsa:1024 -keyout ${SYNOPKG_PKGVAR}/umurmur.key -nodes -sha1 -days 365 -out ${SYNOPKG_PKGVAR}/umurmur.crt -batch -config ${SYNOPKG_PKGDEST}/openssl.cnf > /dev/null 2>&1

# Exit with the right code and an explicit message
if [ $? -ne 0 ]; then
    echo "Certificate generation for uMurmur failed"
    touch ${SYNOPKG_PKGVAR}/umurmur.key
    touch ${SYNOPKG_PKGVAR}/umurmur.crt
    exit 1
fi

echo "uMurmur's certificate successfully generated"
exit 0

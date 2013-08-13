#!/bin/sh

PKGNAME="dnsmasq"
PKGPATH="/var/packages/"${PKGNAME}
DNSPKG=`ls -l ${PKGPATH}/target | awk -F "-> " '{print $2}'`
DNSTMPVOL="/"`echo ${DNSPKG} | cut -d'/' -f2`"/@tmp"
DNSPKGTMP=${DNSTMPVOL}/${PKGNAME}
WWW_DIR="/var/packages/${PKGNAME}/target/app"

WEBMAN_DIR="/usr/syno/synoman/webman/3rdparty"


preinst ()
{
    exit 0
}

postinst ()
{

    chown -R admin.users ${DNSPKG}
    # Install ui
    ln -s ${WWW_DIR} ${WEBMAN_DIR}/${PKGNAME}

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    exit 0
}

preupgrade ()
{
    mkdir -p ${DNSPKGTMP}
    cp -rf ${DNSPKG}"/etc" ${DNSPKGTMP}
    cp -rf ${DNSPKG}"/log" ${DNSPKGTMP}
    cp -rf ${DNSPKG}"/lease" ${DNSPKGTMP}
    exit 0
}

postupgrade ()
{
    cp -rf ${DNSPKGTMP}"/etc" ${DNSPKG}
    cp -rf ${DNSPKGTMP}"/log" ${DNSPKG}
    cp -rf ${DNSPKGTMP}"/lease" ${DNSPKG}
    rm -rf ${DNSPKGTMP}
    chown -R admin.users ${DNSPKG}
    exit 0
}

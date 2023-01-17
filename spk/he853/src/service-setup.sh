
UDEVRULE="80-${SYNOPKG_PKGNAME}.rules"
UDEVBASE="/lib/udev/rules.d/"
LOCALBIN="/usr/local/bin"

service_postinst ()
{
    mkdir -p ${LOCALBIN}
    ln -s ${SYNOPKG_PKGDEST}bin/he853 ${LOCALBIN}
    ln -s ${SYNOPKG_PKGDEST}${UDEVBASE}${UDEVRULE} ${UDEVBASE}
}

service_postuninst ()
{
    rm -f ${UDEVBASE}${UDEVRULE} ${LOCALBIN}/he853
}

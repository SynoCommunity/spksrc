
UDEVRULE="80-${SYNOPKG_PKGNAME}.rules"
UDEVBASE="/lib/udev/rules.d/"

service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}${UDEVBASE}${UDEVRULE} ${UDEVBASE}
}

service_postuninst ()
{
    rm -f ${UDEVBASE}${UDEVRULE}
}

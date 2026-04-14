
service_postinst ()
{
    cp ${SYNOPKG_PKGDEST}/bin/test.cgi ${SYNOPKG_PKGDEST}/app/

    /bin/sqlite3 ${SYNOPKG_PKGHOME}/api.db <${SYNOPKG_PKGDEST}/app/createsqlitedata.sql
}

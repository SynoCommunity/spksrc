# Credentials come from the installation wizard environment, never arguments.
service_postinst ()
{
    umask 077
    "${SYNOPKG_PKGDEST}/bin/repo-sync" --init-admin
}

service_postupgrade ()
{
    service_postinst
}

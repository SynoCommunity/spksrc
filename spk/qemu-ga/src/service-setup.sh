
service_postinst ()
{
   # ensure var/run folder exists
   mkdir -p ${SYNOPKG_PKGVAR}/run
}

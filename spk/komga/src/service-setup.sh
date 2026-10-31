# komga service setup

KOMGA="${SYNOPKG_PKGDEST}/bin/komga.jar"
KOMGA_TMP="${SYNOPKG_PKGDEST}/tmp"

SERVICE_COMMAND="java -Djava.io.tmpdir=${KOMGA_TMP} -jar ${KOMGA}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst() {}

service_restore() {}

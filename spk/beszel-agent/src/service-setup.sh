
KEY_FILE=${SYNOPKG_PKGVAR}/key.pub
BESZEL_PUBLIC_KEY=$(cat ${KEY_FILE})
export KEY=${BESZEL_PUBLIC_KEY}

BESZEL_AGENT=${SYNOPKG_PKGDEST}/bin/beszel-agent
SERVICE_COMMAND="${BESZEL_AGENT}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
   echo "${wizard_pub_key}" > ${KEY_FILE}
}

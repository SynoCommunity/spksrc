
KEY_FILE="${SYNOPKG_PKGVAR}/key.pub"

# Read the public key from the saved file
if [ -f "${KEY_FILE}" ]; then
    BESZEL_PUBLIC_KEY=$(cat "${KEY_FILE}")
    export KEY="${BESZEL_PUBLIC_KEY}"
fi

BESZEL_AGENT="${SYNOPKG_PKGDEST}/bin/beszel-agent"
SERVICE_COMMAND="${BESZEL_AGENT}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Save the public key provided during installation
    # This will persist across updates in SYNOPKG_PKGVAR
    echo "${wizard_pub_key}" > "${KEY_FILE}"
}


KEY_FILE="${SYNOPKG_PKGVAR}/key.pub"

# Read the public key from the saved file
if [ -f "${KEY_FILE}" ]; then
    BESZEL_PUBLIC_KEY=$(cat "${KEY_FILE}")
    export KEY="${BESZEL_PUBLIC_KEY}"
fi

# Read the extra filesystems from the saved file
if [ -f "${SYNOPKG_PKGVAR}/extra_fs.conf" ]; then
    EXTRA_FS=$(cat "${SYNOPKG_PKGVAR}/extra_fs.conf")
    export EXTRA_FILESYSTEMS="${EXTRA_FS}"
fi

BESZEL_AGENT="${SYNOPKG_PKGDEST}/bin/beszel-agent"
SERVICE_COMMAND="${BESZEL_AGENT}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Save the public key
    echo "${wizard_pub_key}" > "${SYNOPKG_PKGVAR}/key.pub"

    # Save the extra filesystems
    echo "${wizard_extra_fs}" > "${SYNOPKG_PKGVAR}/extra_fs.conf"
}

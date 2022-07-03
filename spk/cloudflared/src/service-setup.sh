TOKEN_FILE="${SYNOPKG_PKGVAR}/token"

# Read token from file
if [ -e $TOKEN_FILE ]; then
    CLOUDFLARED_TOKEN="$(cat $TOKEN_FILE)"
fi

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/cloudflared --no-autoupdate tunnel run --token ${CLOUDFLARED_TOKEN}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Save token to file
    if [ -n "${wizard_cloudflared_token}" ]; then
        echo "${wizard_cloudflared_token}" >> ${TOKEN_FILE}
    fi
}

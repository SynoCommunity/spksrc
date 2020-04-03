# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

service_postinst ()
{
    # setuid for proper vaapi access
    chmod u+s /var/packages/ffmpeg/target/bin/ffmpeg
}

service_postupgrade ()
{
    # setuid for proper vaapi access
    chmod u+s /var/packages/ffmpeg/target/bin/ffmpeg
}

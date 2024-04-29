[go2rtc]
title="go2rtc API (HTTP)"
desc="go2rtc API"
port_forward="yes"
dst.ports="1984/tcp"

[go2rtc_rtsp]
title="go2rtc RTSP (TCP)"
desc="go2rtc RTSP"
port_forward="yes"
dst.ports="8554/tcp"

[go2rtc_webrtc]
title="go2rtc WebRTC (TCP,UDP)"
desc="go2rtc WebRTC"
port_forward="yes"
dst.ports="8555"

[go2rtc_srtp]
title="go2rtc SRTP (UDP)"
desc="go2rtc SRTP"
port_forward="yes"
dst.ports="18443/udp"

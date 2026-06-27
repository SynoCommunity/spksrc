[shairport-sync_tcp]
title="Shairport Sync TCP"
desc="Shairport Sync TCP"
port_forward="yes"
dst.ports="8303/tcp"

[shairport-sync_udp]
title="Shairport Sync UDP"
desc="Shairport Sync UDP"
port_forward="yes"
dst.ports="8304:8313/udp"

[shairport-sync_nqptp]
title="NQPTP PTP Timing"
desc="Network Quasi-Precision Time Protocol for AirPlay 2"
port_forward="yes"
dst.ports="319,320/udp"

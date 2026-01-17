[rustdesk-server_nat]
title="RustDesk NAT Test (TCP)"
desc="NAT type test"
port_forward="yes"
dst.ports="21115/tcp"

[rustdesk-server_id]
title="RustDesk ID Server (TCP+UDP)"
desc="ID/Rendezvous server"
port_forward="yes"
dst.ports="21116"

[rustdesk-server_relay]
title="RustDesk Relay (TCP)"
desc="Relay server"
port_forward="yes"
dst.ports="21117/tcp"

[rustdesk-server_id_ws]
title="RustDesk ID Server WebSocket (TCP)"
desc="ID server WebSocket for web clients"
port_forward="yes"
dst.ports="21118/tcp"

[rustdesk-server_relay_ws]
title="RustDesk Relay Server WebSocket (TCP)"
desc="Relay server WebSocket for web clients"
port_forward="yes"
dst.ports="21119/tcp"

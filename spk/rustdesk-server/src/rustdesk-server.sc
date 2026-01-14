[rustdesk-server_nat]
title="RustDesk NAT Test (TCP)"
desc="RustDesk NAT type test"
port_forward="yes"
dst.ports="21115/tcp"

[rustdesk-server_id]
title="RustDesk ID Server (TCP+UDP)"
desc="RustDesk ID/Rendezvous server"
port_forward="yes"
dst.ports="21116"

[rustdesk-server_relay]
title="RustDesk Relay (TCP)"
desc="RustDesk relay server"
port_forward="yes"
dst.ports="21117/tcp"

[rustdesk-server_ws]
title="RustDesk WebSocket (TCP)"
desc="RustDesk websocket for web clients"
port_forward="yes"
dst.ports="21118/tcp"

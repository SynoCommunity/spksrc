[syncthing_bep]
title="BEP (Block Exchange Protocol)"
desc="Syncthing File Synchronization"
port_forward="yes"
dst.ports="22000/tcp"

[syncthing_discovery]
title="Local Discovery Protocol"
desc="Syncthing Local Announcement"
port_forward="no"
dst.ports="21027/udp"

[syncthing_webui]
title="HTTP(S)"
desc="Syncthing Web GUI"
port_forward="yes"
dst.ports="8384/tcp"

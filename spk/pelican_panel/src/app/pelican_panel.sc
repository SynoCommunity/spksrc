[pelican_panel]
title="Pelican Panel Web"
desc="Interface web du Panel Pelican"
port_forward="yes"
dst.ports="8080/tcp"

[pelican_loading]
title="Pelican Loading Page"
desc="Page de chargement pendant le démarrage"
port_forward="no"
dst.ports="8081/tcp"

[pelican_wings]
title="Pelican Wings API"
desc="API Wings (HTTPS) pour la gestion des serveurs"
port_forward="yes"
dst.ports="8443/tcp"

[pelican_sftp]
title="Pelican SFTP"
desc="Serveur SFTP pour l'accès aux fichiers des serveurs de jeux"
port_forward="yes"
dst.ports="2022/tcp"

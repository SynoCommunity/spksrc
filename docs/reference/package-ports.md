# Package Ports

This page documents port allocations for SynoCommunity packages.

For Synology system service ports, see [System Ports](system-ports.md).

## Package Port Allocations

The following ports are used by SynoCommunity packages.

<p>
  <label>Category:
    <select id="catFilter" onchange="filterPortTable()">
      <option value="">All</option>
      <option value="Backup">Backup</option>
      <option value="Communication">Communication</option>
      <option value="Development">Development</option>
      <option value="Downloads">Downloads</option>
      <option value="Games">Games</option>
      <option value="Home Automation">Home Automation</option>
      <option value="Media Management">Media Management</option>
      <option value="Media Server">Media Server</option>
      <option value="Messaging">Messaging</option>
      <option value="Monitoring">Monitoring</option>
      <option value="Network">Network</option>
      <option value="Security">Security</option>
      <option value="Storage">Storage</option>
      <option value="Sync">Sync</option>
      <option value="Utilities">Utilities</option>
    </select>
  </label>
  &nbsp;
  <input id="portSearch" type="text" placeholder="Search port number or package…" oninput="filterPortTable()" size="30">
</p>

<table id="portTable" markdown="0">
  <thead>
    <tr><th>Port</th><th>Package</th><th>Category</th><th>Description</th></tr>
  </thead>
  <tbody>
    <tr data-category="Network"><td>53</td><td>dnscrypt-proxy</td><td>Network</td><td>DNS encryption proxy</td></tr>
    <tr data-category="Utilities"><td>667</td><td>darkstat</td><td>Network</td><td>Network statistics</td></tr>
    <tr data-category="Home Automation"><td>1883</td><td>mosquitto</td><td>Home Automation</td><td>MQTT broker</td></tr>
    <tr data-category="Media Server"><td>1925</td><td>Loom</td><td>Media Server</td><td>Web UI and API</td></tr>
    <tr data-category="Media Server"><td>1984</td><td>go2rtc</td><td>Media Server</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>2812</td><td>monit</td><td>Development</td><td>Web interface</td></tr>
    <tr data-category="Network"><td>3000</td><td>ntopng</td><td>Network</td><td>Web interface</td></tr>
    <tr data-category="Utilities"><td>3001</td><td>uptime-kuma</td><td>Utilities</td><td>Uptime monitoring</td></tr>
    <tr data-category="Media Server"><td>4533</td><td>Navidrome</td><td>Media Server</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>5050</td><td>Couchpotato</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>5053</td><td>Couchpotato (custom)</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>5055</td><td>Seerr</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>5075</td><td>NZBHydra</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Utilities"><td>5244</td><td>OpenList</td><td>Utilities</td><td>Web interface</td></tr>
    <tr data-category="Communication"><td>5280</td><td>ejabberd</td><td>Communication</td><td>HTTP admin</td></tr>
    <tr data-category="Development"><td>5433</td><td>PostgreSQL</td><td>Development</td><td>Database</td></tr>
    <tr data-category="Media Server"><td>5500</td><td>Kavita</td><td>Media Server</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>6060</td><td>Plexivity</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>6379</td><td>Redis</td><td>Development</td><td>Database</td></tr>
    <tr data-category="Media Management"><td>6767</td><td>Bazarr</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>6789</td><td>NZBGet</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>6800</td><td>Aria2</td><td>Downloads</td><td>RPC interface</td></tr>
    <tr data-category="Utilities"><td>7152</td><td>Gotify</td><td>Utilities</td><td>Web interface</td></tr>
    <tr data-category="Media Server"><td>8000</td><td>Icecast</td><td>Media Server</td><td>Streaming</td></tr>
    <tr data-category="Downloads"><td>8050</td><td>ruTorrent</td><td>Downloads</td><td>RPC interface</td></tr>
    <tr data-category="Downloads"><td>8080</td><td>SABnzbd</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8081</td><td>SickChill</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8082</td><td>LazyLibrarian</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8083</td><td>SickBeard</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8086</td><td>NZBMegaSearch</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8087</td><td>HTPC Manager</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>8088</td><td>OctoPrint</td><td>Development</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8090</td><td>Mylar</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Utilities"><td>8091</td><td>File Browser</td><td>Utilities</td><td>Web file browser</td></tr>
    <tr data-category="Media Server"><td>8092</td><td>Kiwix</td><td>Media Server</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>8095</td><td>qBittorrent</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8096</td><td>Jellyfin</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>8112</td><td>Deluge</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Home Automation"><td>8123</td><td>Home Assistant</td><td>Home Automation</td><td>Web interface</td></tr>
    <tr data-category="Sync"><td>8132</td><td>FF Sync</td><td>Sync</td><td>Web interface</td></tr>
    <tr data-category="Network"><td>8153</td><td>dnscrypt-proxy</td><td>Network</td><td>DNS management</td></tr>
    <tr data-category="Security"><td>8180</td><td>Vaultwarden</td><td>Security</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8181</td><td>Headphones</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8182</td><td>Headphones (custom)</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Server"><td>8184</td><td>YMPD</td><td>Media Server</td><td>Web interface</td></tr>
    <tr data-category="Media Server"><td>8185</td><td>MyMPD</td><td>Media Server</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>8190</td><td>pyLoad</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Communication"><td>8250</td><td>ZNC</td><td>Communication</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>8260</td><td>Maraschino</td><td>Development</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>8271</td><td>GateOne</td><td>Development</td><td>Terminal emulator</td></tr>
    <tr data-category="Network"><td>8281</td><td>HAProxy</td><td>Network</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>8282</td><td>Salt Master</td><td>Development</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>8283</td><td>SaltPad</td><td>Development</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8290</td><td>FlexGet</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Games"><td>8300</td><td>Stockfish</td><td>Games</td><td>Engine</td></tr>
    <tr data-category="Media Management"><td>8310</td><td>Radarr</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Sync"><td>8384</td><td>Syncthing</td><td>Sync</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>8418</td><td>Gitea</td><td>Development</td><td>Web interface</td></tr>
    <tr data-category="Development"><td>8620</td><td>Forgejo</td><td>Development</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8686</td><td>Lidarr</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8787</td><td>Readarr</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8822</td><td>Ombi</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8899</td><td>SickRage</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>8989</td><td>Sonarr</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Storage"><td>9001</td><td>MinIO</td><td>Storage</td><td>Web interface</td></tr>
    <tr data-category="Downloads"><td>9091</td><td>Transmission</td><td>Downloads</td><td>Web interface</td></tr>
    <tr data-category="Monitoring"><td>9100</td><td>node_exporter</td><td>Monitoring</td><td>Metrics</td></tr>
    <tr data-category="Media Management"><td>9117</td><td>Jackett</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Media Management"><td>9696</td><td>Prowlarr</td><td>Media Management</td><td>Web interface</td></tr>
    <tr data-category="Utilities"><td>9876</td><td>DDNS Go</td><td>Utilities</td><td>Web interface</td></tr>
    <tr data-category="Media Server"><td>9981</td><td>TVHeadend</td><td>Media Server</td><td>Web interface</td></tr>
    <tr data-category="Monitoring"><td>10050</td><td>Zabbix Agent</td><td>Monitoring</td><td>Agent</td></tr>
    <tr data-category="Development"><td>11211</td><td>Memcached</td><td>Development</td><td>Cache</td></tr>
    <tr data-category="Media Server"><td>14167</td><td>PS3 Net Server</td><td>Media Server</td><td>Media server</td></tr>
    <tr data-category="Messaging"><td>15672</td><td>RabbitMQ</td><td>Messaging</td><td>Management UI</td></tr>
    <tr data-category="Development"><td>18888</td><td>Demo Service</td><td>Development</td><td>Demo</td></tr>
    <tr data-category="Development"><td>18889</td><td>Demo Web Service</td><td>Development</td><td>Demo</td></tr>
    <tr data-category="Monitoring"><td>19999</td><td>Netdata</td><td>Monitoring</td><td>Dashboard</td></tr>
    <tr data-category="Backup"><td>51515</td><td>Kopia</td><td>Backup</td><td>Web interface</td></tr>

  </tbody>
</table>

<script>
function filterPortTable() {
  var f = document.getElementById('catFilter').value;
  var q = document.getElementById('portSearch').value.toLowerCase();
  document.querySelectorAll('#portTable tbody tr').forEach(function (r) {
    var okCat = !f || r.getAttribute('data-category') === f;
    var okText = !q || r.textContent.toLowerCase().indexOf(q) >= 0;
    r.style.display = okCat && okText ? '' : 'none';
  });
}
</script>

## WebStation Applications

Packages served through DSM WebStation reverse proxy on port 80 (HTTP).

| URL Path | Package | Description |
|----------|---------|-------------|
| `/adminer/` | Adminer | Database management |
| `/ariang/` | AriaNg | Download manager UI |
| `/bbs/` | BicBucStriim | eBook server |
| `/cops/` | COPS | OPDS and HTML PHP server |
| `/fengoffice/` | Feng Office | Office suite |
| `/mantisbt/` | MantisBT | Bug tracker |
| `/nextcloud/` | Nextcloud | File sync and share |
| `/owncloud/` | ownCloud | File sync and share |
| `/phpmemcachedadmin/` | PHP Memcached Admin | Memcached administration |
| `/roundcube/` | Roundcube | Webmail |
| `/rutorrent/` | ruTorrent | ruTorrent RPC |
| `/selfoss/` | Selfoss | RSS reader |
| `/tt-rss/` | Tiny Tiny RSS | RSS reader |
| `/wallabag/` | Wallabag | Read-it-later service |

Packages that depend on WebStation but also provide a `SERVICE_PORT` (e.g. ruTorrent) are also listed in the numerical port table above.

## Choosing Ports for New Packages

### Guidelines

1. **Avoid system ports** - Don't use ports below 1024 without good reason
2. **Check conflicts** - Search this page and Synology docs
3. **Use upstream defaults** - If the software has a common port, use it
4. **Document the port** - Add to `SERVICE_PORT` in Makefile
5. **Consider firewall** - Use port-config resource files

### Recommended Ranges

| Range | Use Case |
|-------|----------|
| 1024-49151 | Registered ports (prefer upstream defaults) |
| 49152-65535 | Dynamic/private (use for internal services) |

### Registering New Ports

When adding a new package with a dedicated port:

1. Check this documentation for conflicts
2. Use the upstream project's default port if possible
3. Document the port in your package's Makefile:

```makefile
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Web Interface
```

4. Consider opening a PR to update this documentation

## External References

- [IANA Service Name and Transport Protocol Port Number Registry](https://www.iana.org/assignments/service-names-port-numbers/)

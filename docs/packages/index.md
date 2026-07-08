---
title: Package Catalog
description: Complete list of packages available from SynoCommunity
tags:
  - packages
  - catalog
---

# Package Catalog

SynoCommunity provides a wide variety of open-source packages for Synology NAS devices.

Packages with detailed documentation are linked below. For packages without dedicated pages, see the [spksrc repository](https://github.com/SynoCommunity/spksrc/tree/master/spk) for package sources.

## Documented Packages

<p>
  <label>Category:
    <select id="pkgCatFilter" onchange="filterPkgTable()">
      <option value="">All</option>
      <option value="Backup">Backup</option>
      <option value="CLI">CLI</option>
      <option value="Development">Development</option>
      <option value="Downloads">Downloads</option>
      <option value="Home Automation">Home Automation</option>
      <option value="Kernel">Kernel</option>
      <option value="Media">Media</option>
      <option value="Media Management">Media Management</option>
      <option value="Media Server">Media Server</option>
      <option value="Monitoring">Monitoring</option>
      <option value="Network">Network</option>
      <option value="Runtime">Runtime</option>
      <option value="Security">Security</option>
      <option value="Storage">Storage</option>
      <option value="Sync">Sync</option>
      <option value="Utilities">Utilities</option>
      <option value="Web Apps">Web Apps</option>
    </select>
  </label>
  &nbsp;
  <input id="pkgSearch" type="text" placeholder="Search package…" oninput="filterPkgTable()" size="30">
</p>

<!-- href targets use mkdocs directory URLs (no .md extension) -->
<table id="pkgTable" markdown="0">
  <thead>
    <tr><th>Package</th><th>Category</th><th>Description</th></tr>
  </thead>
  <tbody>
    <tr data-category="Network"><td><a href="adguardhome/">AdGuard Home</a></td><td>Network</td><td>Network-wide ad blocking</td></tr>
    <tr data-category="Web Apps"><td><a href="adminer/">Adminer</a></td><td>Web Apps</td><td>Database management</td></tr>
    <tr data-category="Downloads"><td><a href="aria2/">Aria2</a></td><td>Downloads</td><td>Multi-protocol download utility</td></tr>
    <tr data-category="Media"><td><a href="beets/">Beets</a></td><td>Media</td><td>Music library management</td></tr>
    <tr data-category="Web Apps"><td><a href="bicbucstriim/">BicBucStriim</a></td><td>Web Apps</td><td>eBook server</td></tr>
    <tr data-category="Backup"><td><a href="borgbackup/">BorgBackup</a></td><td>Backup</td><td>Deduplicating backup</td></tr>
    <tr data-category="Backup"><td><a href="borgmatic/">Borgmatic</a></td><td>Backup</td><td>BorgBackup automation</td></tr>
    <tr data-category="Network"><td><a href="cloudflared/">Cloudflared</a></td><td>Network</td><td>Cloudflare Tunnel client</td></tr>
    <tr data-category="Media"><td><a href="comskip/">Comskip</a></td><td>Media</td><td>Commercial detector for recorded TV</td></tr>
    <tr data-category="Downloads"><td><a href="deluge/">Deluge</a></td><td>Downloads</td><td>Feature-rich BitTorrent client</td></tr>
    <tr data-category="Network"><td><a href="dnscrypt-proxy/">DNSCrypt Proxy</a></td><td>Network</td><td>DNS encryption proxy</td></tr>
    <tr data-category="Utilities"><td><a href="dsm-utilities/">DSM Utilities</a></td><td>Utilities</td><td>Helpful DSM configuration for packages</td></tr>
    <tr data-category="Backup"><td><a href="duplicity/">Duplicity</a></td><td>Backup</td><td>Encrypted bandwidth-efficient backup</td></tr>
    <tr data-category="Media"><td><a href="ffmpeg/">FFmpeg</a></td><td>Media</td><td>Complete multimedia framework</td></tr>
    <tr data-category="Web Apps"><td><a href="file-browser/">File Browser</a></td><td>Web Apps</td><td>Web file browser</td></tr>
    <tr data-category="Media Management"><td><a href="flexget/">Flexget</a></td><td>Media Management</td><td>Multipurpose automation</td></tr>
    <tr data-category="Development"><td><a href="git/">Git</a></td><td>Development</td><td>Version control system</td></tr>
    <tr data-category="Security"><td><a href="google-authenticator/">Google Authenticator</a></td><td>Security</td><td>PAM module for two-factor authentication</td></tr>
    <tr data-category="Home Automation"><td><a href="homeassistant/">Home Assistant</a></td><td>Home Automation</td><td>Home automation platform</td></tr>
    <tr data-category="Media Server"><td><a href="jellyfin/">Jellyfin</a></td><td>Media Server</td><td>Media streaming server</td></tr>
    <tr data-category="Media Server"><td><a href="kiwix/">Kiwix</a></td><td>Media Server</td><td>Offline Wikipedia and content server</td></tr>
    <tr data-category="Media Server"><td><a href="loom/">Loom</a></td><td>Media Server</td><td>Federated and encrypted live streaming</td></tr>
    <tr data-category="Storage"><td><a href="minio/">MinIO</a></td><td>Storage</td><td>S3-compatible object storage</td></tr>
    <tr data-category="Runtime"><td><a href="mono/">Mono</a></td><td>Runtime</td><td>.NET runtime</td></tr>
    <tr data-category="CLI"><td><a href="mosh/">Mosh</a></td><td>CLI</td><td>Mobile shell for intermittent connectivity</td></tr>
    <tr data-category="Home Automation"><td><a href="mosquitto/">Mosquitto</a></td><td>Home Automation</td><td>MQTT message broker</td></tr>
    <tr data-category="Web Apps"><td><a href="mozilla-sync/">Mozilla Sync</a></td><td>Web Apps</td><td>Firefox Sync server</td></tr>
    <tr data-category="Media Server"><td><a href="navidrome/">Navidrome</a></td><td>Media Server</td><td>Music streaming server</td></tr>
    <tr data-category="Monitoring"><td><a href="node-exporter/">Node Exporter</a></td><td>Monitoring</td><td>Prometheus metrics exporter</td></tr>
    <tr data-category="Web Apps"><td><a href="openlist/">OpenList</a></td><td>Web Apps</td><td>Web bookmark management</td></tr>
    <tr data-category="Web Apps"><td><a href="owncloud/">ownCloud</a></td><td>Web Apps</td><td>File sync and share platform</td></tr>
    <tr data-category="Media Management"><td><a href="radarr-sonarr/">Radarr/Sonarr</a></td><td>Media Management</td><td>Movie &amp; TV series management</td></tr>
    <tr data-category="Backup"><td><a href="rclone/">Rclone</a></td><td>Backup</td><td>Cloud storage sync tool</td></tr>
    <tr data-category="Downloads"><td><a href="rutorrent/">ruTorrent</a></td><td>Downloads</td><td>Web-based BitTorrent client</td></tr>
    <tr data-category="Automation"><td><a href="salt/">Salt</a></td><td>Automation</td><td>Infrastructure automation</td></tr>
    <tr data-category="Media Management"><td><a href="sickbeard-custom/">SickBeard Custom</a></td><td>Media Management</td><td>SickBeard fork selector (archived)</td></tr>
    <tr data-category="Sync"><td><a href="syncthing/">Syncthing</a></td><td>Sync</td><td>Continuous file synchronization</td></tr>
    <tr data-category="CLI"><td><a href="synocli-devel/">SynoCli Devel</a></td><td>CLI</td><td>Development tools</td></tr>
    <tr data-category="CLI"><td><a href="synocli-disk/">SynoCli Disk</a></td><td>CLI</td><td>Disk utilities</td></tr>
    <tr data-category="CLI"><td><a href="synocli-file/">SynoCli File</a></td><td>CLI</td><td>File management tools</td></tr>
    <tr data-category="CLI"><td><a href="synocli-kernel/">SynoCli Kernel</a></td><td>CLI</td><td>Kernel module management</td></tr>
    <tr data-category="CLI"><td><a href="synocli-misc/">SynoCli Misc</a></td><td>CLI</td><td>Miscellaneous utilities</td></tr>
    <tr data-category="CLI"><td><a href="synocli-monitor/">SynoCli Monitor</a></td><td>CLI</td><td>System monitoring tools</td></tr>
    <tr data-category="CLI"><td><a href="synocli-net/">SynoCli Net</a></td><td>CLI</td><td>Network utilities</td></tr>
    <tr data-category="CLI"><td><a href="synocli-videodriver/">SynoCli VideoDriver</a></td><td>CLI</td><td>Intel GPU drivers for hardware transcoding</td></tr>
    <tr data-category="Kernel"><td><a href="synokernel-usbserial/">SynoKernel USB Serial</a></td><td>Kernel</td><td>USB serial adapter drivers</td></tr>
    <tr data-category="Downloads"><td><a href="transmission/">Transmission</a></td><td>Downloads</td><td>Lightweight BitTorrent client</td></tr>
    <tr data-category="Security"><td><a href="vaultwarden/">Vaultwarden</a></td><td>Security</td><td>Bitwarden-compatible password manager</td></tr>
  </tbody>
</table>

<script>
function filterPkgTable() {
  var f = document.getElementById('pkgCatFilter').value;
  var q = document.getElementById('pkgSearch').value.toLowerCase();
  document.querySelectorAll('#pkgTable tbody tr').forEach(function (r) {
    var okCat = !f || r.getAttribute('data-category') === f;
    var okText = !q || r.textContent.toLowerCase().indexOf(q) >= 0;
    r.style.display = okCat && okText ? '' : 'none';
  });
}
</script>

For the most up-to-date list of packages, visit [synocommunity.com/packages](https://synocommunity.com/packages).

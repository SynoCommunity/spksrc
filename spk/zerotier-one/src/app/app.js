// zerotier-one — DSM app: node status, joined networks, join and leave.
// Runs inside a DSM window (iframe). Talks only to cgi/api.cgi, sending the
// DSM session's SynoToken so DSM can verify the signed-in administrator.
(function () {
  'use strict';

  var T = {
    enu: {
      subtitle: 'Join this NAS to your ZeroTier networks',
      nodeId: 'Node ID', version: 'Version', networks: 'Networks',
      joinTitle: 'Join a network', networkId: 'Network ID', join: 'Join',
      joinHint: 'After joining, authorise this node in your network controller.',
      networksTitle: 'Joined networks', loading: 'Loading…', none: 'This NAS has not joined any network yet.',
      leave: 'Leave', confirmLeave: 'Leave? ZeroTier restarts: other networks pause for a few seconds.', yes: 'Yes, leave', no: 'Cancel',
      online: 'Online', offline: 'Offline', tunneled: 'Online (relayed)', down: 'Service stopped',
      ips: 'Addresses', noIp: 'no address yet', type: 'Type', mac: 'MAC',
      st_OK: 'Connected', st_ACCESS_DENIED: 'Waiting for authorisation', st_REQUESTING_CONFIGURATION: 'Connecting…',
      st_NOT_FOUND: 'Network not found', st_PORT_ERROR: 'Port error', st_CLIENT_TOO_OLD: 'Client too old',
      helpDenied: 'Authorise node {0} in the controller of this network.',
      badId: 'A network ID is 16 hexadecimal characters.', joined: 'Joined {0}.', left: 'Left {0}. ZeroTier is restarting, back in a few seconds…',
      e_401: 'Your DSM session has expired: sign in again.', e_403: 'Only administrators can manage ZeroTier.',
      e_503: 'ZeroTier is not running. Check the package in Package Center.', e_net: 'Cannot reach the NAS.',
      e_generic: 'Something went wrong ({0}).'
    },
    ita: {
      subtitle: 'Collegamento del NAS alle reti ZeroTier',
      nodeId: 'ID del nodo', version: 'Versione', networks: 'Reti',
      joinTitle: 'Collegamento a una rete', networkId: 'ID della rete', join: 'Collega',
      joinHint: 'Dopo il collegamento il nodo va autorizzato nel controller della rete.',
      networksTitle: 'Reti collegate', loading: 'Caricamento…', none: 'Questo NAS non è ancora collegato a nessuna rete.',
      leave: 'Scollega', confirmLeave: 'Scollegare il NAS da questa rete? ZeroTier si riavvia: le altre reti si fermano per qualche secondo.', yes: 'Sì, scollega', no: 'Annulla',
      online: 'Online', offline: 'Offline', tunneled: 'Online (via relay)', down: 'Servizio fermo',
      ips: 'Indirizzi', noIp: 'ancora nessun indirizzo', type: 'Tipo', mac: 'MAC',
      st_OK: 'Collegata', st_ACCESS_DENIED: 'In attesa di autorizzazione', st_REQUESTING_CONFIGURATION: 'Connessione…',
      st_NOT_FOUND: 'Rete inesistente', st_PORT_ERROR: 'Errore di porta', st_CLIENT_TOO_OLD: 'Client troppo vecchio',
      helpDenied: 'Il nodo {0} va autorizzato nel controller di questa rete.',
      badId: 'Un ID di rete è composto da 16 caratteri esadecimali.', joined: 'Collegato a {0}.', left: 'Scollegato dalla rete {0}. ZeroTier si sta riavviando: la pagina si aggiorna tra qualche secondo…',
      e_401: 'Sessione DSM scaduta: è necessario accedere di nuovo.', e_403: 'Solo gli amministratori possono gestire ZeroTier.',
      e_503: 'ZeroTier non è in esecuzione: verificare il pacchetto nel Centro pacchetti.', e_net: 'Il NAS non risponde.',
      e_generic: 'Operazione non riuscita ({0}).'
    }
  };

  function dsm() { try { return window.parent && window.parent !== window && window.parent.SYNO ? window.parent : null; } catch (e) { return null; } }

  // Opened on its own (bookmark, old link): reopen inside DSM, where the page
  // gets the session's SynoToken.
  if (!dsm()) {
    window.location.replace('/?launchApp=SynoCommunity.ZeroTierOne.Instance');
    return;
  }
  function lang() {
    var p = dsm();
    var l = '';
    try { l = p && p._S ? p._S('lang') : ''; } catch (e) { l = ''; }
    if (!l) { l = (navigator.language || '').toLowerCase().indexOf('it') === 0 ? 'ita' : 'enu'; }
    return T[l] ? l : 'enu';
  }
  var L = lang();
  var t = function (key, arg) { var s = T[L][key] || T.enu[key] || key; return arg === undefined ? s : s.replace('{0}', arg); };
  document.documentElement.lang = L === 'ita' ? 'it' : 'en';
  Array.prototype.forEach.call(document.querySelectorAll('[data-t]'), function (el) { el.textContent = t(el.getAttribute('data-t')); });

  function token() {
    var p = dsm();
    try { return (p && p.SYNO.SDS.Session && p.SYNO.SDS.Session.SynoToken) || ''; } catch (e) { return ''; }
  }

  function api(action, method, id) {
    var url = 'cgi/api.cgi?action=' + encodeURIComponent(action) + (id ? '&id=' + encodeURIComponent(id) : '');
    return fetch(url, { method: method, credentials: 'same-origin', headers: { 'X-SYNO-TOKEN': token() } })
      .then(function (res) {
        return res.json().catch(function () { return {}; }).then(function (body) {
          if (!res.ok) { var err = new Error(body.error || String(res.status)); err.status = res.status; throw err; }
          return body;
        });
      });
  }

  var $ = function (id) { return document.getElementById(id); };
  function say(text, isError) { var m = $('message'); m.textContent = text || ''; m.className = 'zt-msg' + (isError ? ' err' : ''); }
  function explain(err) {
    if (err && err.status && T[L]['e_' + err.status]) { return t('e_' + err.status); }
    if (err instanceof TypeError) { return t('e_net'); }
    return t('e_generic', err && err.message);
  }
  function el(tag, cls, text) { var e = document.createElement(tag); if (cls) { e.className = cls; } if (text !== undefined) { e.textContent = text; } return e; }

  var nodeAddress = '';

  function renderStatus(status) {
    $('node').hidden = false;
    nodeAddress = status.address || '';
    $('node-id').textContent = nodeAddress;
    $('node-version').textContent = status.version || '';
    var pill = $('node-state');
    if (!status.online) { pill.textContent = t('offline'); pill.className = 'zt-pill bad'; }
    else if (status.tcpFallbackActive) { pill.textContent = t('tunneled'); pill.className = 'zt-pill warn'; }
    else { pill.textContent = t('online'); pill.className = 'zt-pill ok'; }
  }

  function renderNetworks(networks) {
    var box = $('networks');
    box.textContent = '';
    $('node-count').textContent = String(networks.length);
    if (!networks.length) { box.appendChild(el('p', 'zt-muted', t('none'))); return; }
    networks.sort(function (a, b) { return (a.name || a.id).localeCompare(b.name || b.id); });
    networks.forEach(function (n) {
      var row = el('div', 'zt-net');
      var main = el('div');
      main.appendChild(el('div', 'zt-net-name', n.name || n.id));
      var meta = el('div', 'zt-net-meta');
      meta.appendChild(el('span', 'mono', n.id));
      var ips = (n.assignedAddresses || []).join(', ');
      meta.appendChild(el('span', '', t('ips') + ': ' + (ips || t('noIp'))));
      if (n.type) { meta.appendChild(el('span', '', t('type') + ': ' + n.type)); }
      if (n.mac) { meta.appendChild(el('span', 'mono', t('mac') + ': ' + n.mac)); }
      main.appendChild(meta);
      row.appendChild(main);

      var side = el('div', 'zt-net-side');
      var stateKey = 'st_' + n.status;
      var pill = el('span', 'zt-pill ' + (n.status === 'OK' ? 'ok' : (n.status === 'ACCESS_DENIED' || n.status === 'REQUESTING_CONFIGURATION') ? 'warn' : 'bad'),
        T[L][stateKey] ? t(stateKey) : n.status);
      side.appendChild(pill);
      var leave = el('button', 'zt-btn zt-danger', t('leave'));
      leave.type = 'button';
      leave.addEventListener('click', function () { confirmLeave(side, n); });
      side.appendChild(leave);
      row.appendChild(side);

      if (n.status === 'ACCESS_DENIED') { row.appendChild(el('p', 'zt-net-help', t('helpDenied', nodeAddress))); }
      box.appendChild(row);
    });
  }

  // The periodic refresh rebuilds the list: hold it while a leave waits for
  // confirmation, or the question would vanish under the user's pointer.
  var confirming = false;
  // After a leave zerotier-one restarts: errors in that window are expected.
  var quietUntil = 0;

  function confirmLeave(side, n) {
    confirming = true;
    side.textContent = '';
    side.appendChild(el('span', '', t('confirmLeave')));
    var yes = el('button', 'zt-btn zt-danger', t('yes'));
    var no = el('button', 'zt-btn', t('no'));
    yes.type = no.type = 'button';
    yes.addEventListener('click', function () {
      yes.disabled = no.disabled = true;
      api('leave', 'POST', n.id).then(function () { confirming = false; quietUntil = Date.now() + 30000; say(t('left', n.name || n.id)); setTimeout(refresh, 20000); })
        .catch(function (err) { confirming = false; say(explain(err), true); refresh(); });
    });
    no.addEventListener('click', function () { confirming = false; refresh(); });
    side.appendChild(yes);
    side.appendChild(no);
    yes.focus();
  }

  var busy = false;
  function refresh() {
    if (busy) { return; }
    busy = true;
    api('status', 'GET').then(function (data) {
      renderStatus(data.status || {});
      renderNetworks(data.networks || []);
      if ($('message').className.indexOf('err') >= 0) { say(''); }
    }).catch(function (err) {
      if (Date.now() < quietUntil) { return; }
      var pill = $('node-state');
      pill.textContent = err.status === 503 ? t('down') : '—';
      pill.className = 'zt-pill bad';
      say(explain(err), true);
    }).then(function () { busy = false; });
  }

  $('join').addEventListener('submit', function (ev) {
    ev.preventDefault();
    var input = $('join-id');
    var id = input.value.trim().toLowerCase();
    if (!/^[0-9a-f]{16}$/.test(id)) { say(t('badId'), true); input.focus(); return; }
    var btn = ev.target.querySelector('button');
    btn.disabled = true;
    api('join', 'POST', id).then(function () { input.value = ''; say(t('joined', id)); refresh(); })
      .catch(function (err) { say(explain(err), true); })
      .then(function () { btn.disabled = false; });
  });

  refresh();
  setInterval(function () { if (!document.hidden && !confirming) { refresh(); } }, 10000);
})();

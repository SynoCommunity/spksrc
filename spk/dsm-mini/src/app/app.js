// The settings screen inside DSM — and, since there is no install wizard, the
// place where the package is set up in the first place.
//
// Plain DOM, no framework and no build step: the page is served straight out
// of the package by DSM's web server, and anything that needed bundling would
// have to be built and committed for a screen this small.
//
// Every request goes through api.cgi, which is the only thing that can reach
// the service: it listens on loopback and a browser cannot. Authorisation is
// the service's job — see internal/dsmui.
(function () {
  'use strict';

  var DICT = window.DSMMINI_I18N || {};
  var LANG = (function () {
    var want = (navigator.language || 'en').toLowerCase();
    if (DICT[want]) return want;
    var short = want.split('-')[0];
    return DICT[short] ? short : 'en';
  })();

  // t looks a string up and fills in {name} placeholders.
  function t(key, vars) {
    var pack = DICT[LANG] || {};
    var s = pack[key] || (DICT.en && DICT.en[key]) || key;
    Object.keys(vars || {}).forEach(function (k) { s = s.split('{' + k + '}').join(vars[k]); });
    return s;
  }

  // The fields, in the order the screen asks for them, with what an empty one
  // shows. The token is the one example allowed in the repository.
  var LABEL = {
    DSM_USER: 'fDsmUser', DSM_PASSWORD: 'fDsmPassword',
    TELEGRAM_BOT_TOKEN: 'fBotToken', ALLOWED_USER_IDS: 'fAllowedIds', PUBLIC_URL: 'fPublicUrl',
    DSM_URL: 'fDsmUrl', LISTEN_ADDR: 'fListen'
  };
  var EXAMPLE = {
    DSM_USER: 'dsm-mini',
    TELEGRAM_BOT_TOKEN: '1234567890:AAExampleTokenReplaceThisWithYours0',
    ALLOWED_USER_IDS: '123456789,987654321',
    PUBLIC_URL: 'https://nas.example.com'
  };
  var PROBLEM = {
    missing: 'pMissing', https: 'pHttps', url: 'pUrl', ids: 'pIds', listen: 'pListen', loopback: 'pLoopback'
  };

  // DSM's CSRF token. The screen is an iframe of the same origin as the
  // desktop that opened it, so the token can be read from there rather than
  // passed through a URL, where it would end up in logs and referrers.
  //
  // Opened on its own in a browser tab there is no desktop and no token, and
  // DSM will refuse the session — which is the honest outcome: this screen is
  // meant to be reached from the DSM menu.
  function synoToken() {
    try {
      return (window.parent && window.parent.SYNO && window.parent.SYNO.SDS &&
        window.parent.SYNO.SDS.Session && window.parent.SYNO.SDS.Session.SynoToken) || '';
    } catch (e) {
      return '';
    }
  }

  function call(endpoint, method, body) {
    return fetch('api.cgi?p=' + endpoint, {
      method: method || 'GET',
      credentials: 'same-origin',
      headers: { 'Content-Type': 'application/json', 'X-Syno-Token': synoToken() },
      body: body ? JSON.stringify(body) : undefined
    }).then(function (r) {
      return r.json().catch(function () { return {}; }).then(function (data) {
        if (r.ok) return data;
        var err = new Error(data.error || 'request failed');
        err.status = r.status;
        err.field = data.field;
        err.code = data.code;
        throw err;
      });
    });
  }

  function el(tag, attrs, children) {
    var node = document.createElement(tag);
    Object.keys(attrs || {}).forEach(function (k) {
      if (k === 'text') node.textContent = attrs[k];
      else if (k === 'class') node.className = attrs[k];
      else if (k in node) node[k] = attrs[k];
      else node.setAttribute(k, attrs[k]);
    });
    (children || []).forEach(function (c) { if (c) node.appendChild(c); });
    return node;
  }

  function kv(label, value) {
    return el('div', { class: 'kv' }, [el('span', { text: label }), el('span', { text: value })]);
  }

  Array.prototype.forEach.call(document.querySelectorAll('[data-t]'), function (n) {
    n.textContent = t(n.dataset.t);
  });

  var statusBox = document.getElementById('status');
  var app = document.getElementById('app');
  var state = { status: null, settings: null, address: null, tried: false, accessTouched: false };

  // ---- status ------------------------------------------------------------

  function dsmURL() {
    var s = state.settings;
    if (!s) return '';
    return s.values.DSM_URL || (s.defaults && s.defaults.DSM_URL) || '';
  }

  function authText(code) {
    if (code === 400) return t('dsmAuth400');
    if (code === 401) return t('dsmAuth401');
    if (code === 402) return t('dsmAuth402');
    if (code === 403 || code === 404) return t('dsmAuth2fa');
    return t('dsmAuthOther', { code: code });
  }

  function dsmText(l) {
    if (l.state === 'ok') return t('lnOk');
    if (l.reason === 'auth') return authText(l.code);
    if (l.reason === 'unreachable') return t('dsmUnreachable', { url: dsmURL() });
    if (l.reason === 'download_station') return t('dsmNoDS');
    return t('lnWait');
  }

  function botText(l) {
    if (l.state === 'ok') return l.name ? t('lnBotOk', { name: l.name }) : t('lnOk');
    if (l.reason === 'token') return t('botToken');
    if (l.reason === 'unreachable') return t('botUnreachable');
    return t('lnWait');
  }

  function renderStatus(extra) {
    var s = state.status;
    statusBox.textContent = '';
    if (!s) return;

    var kind = { stopped: 'info', starting: 'info', running: 'good', failed: 'bad' }[s.state] || 'info';
    var card = el('div', { class: 'card status ' + kind });
    var blocked = !!s.unreadable || (s.problems || []).length > 0;

    if (s.unreadable) {
      card.appendChild(el('h3', { text: t('stUnread') }));
      card.appendChild(el('p', { text: t('stUnreadText', { owner: s.unreadable.owner || '?' }) }));
      card.appendChild(el('pre', { text: s.unreadable.command }));
    } else if (s.state === 'stopped') {
      card.appendChild(el('h3', { text: t('stStopped') }));
      var missing = (s.problems || []).filter(function (p) { return LABEL[p.key]; })
        .map(function (p) { return t(LABEL[p.key]); });
      card.appendChild(el('p', { text: missing.length ? t('stMissing') + ' ' + missing.join(', ') : t('stStoppedText') }));
    } else {
      card.appendChild(el('h3', { text: t({ starting: 'stStarting', running: 'stRunning', failed: 'stFailed' }[s.state]) }));
      if (s.dsm && s.dsm.state) card.appendChild(kv(t('lnDsm'), dsmText(s.dsm)));
      if (s.bot && s.bot.state) card.appendChild(kv(t('lnBot'), botText(s.bot)));
      // The Mini App line: its address, or why there is none — the bot on
      // its own is a choice, a way chosen and not finished is a to-do.
      if (state.settings) {
        var url = state.settings.values.PUBLIC_URL;
        var way = state.settings.access || (url ? '' : 'bot');
        card.appendChild(kv(t('lnApp'), url ? url : way === 'bot' ? t('lnAppOff') : t('lnAppNoAddr')));
      }
      if (s.bot && s.bot.state === 'ok' && s.bot.name) {
        card.appendChild(el('p', {}, [el('a', {
          href: 'https://t.me/' + encodeURIComponent(s.bot.name), target: '_blank', rel: 'noopener',
          text: t('openBot') + ' @' + s.bot.name
        })]));
      }
    }

    // Start and Stop switch the bot and the Mini App; the process itself
    // keeps running, since it is what answers this window. Start waits for
    // settings that are enough to start on.
    var on = s.state !== 'stopped';
    var toggle = el('button', { class: on ? 'ghost' : '', text: on ? t('btnStop') : t('btnStart') });
    toggle.disabled = !on && blocked;
    toggle.addEventListener('click', function () {
      toggle.disabled = true;
      call('run', 'POST', { enabled: !on }).then(pollStatus).catch(function (err) {
        toggle.disabled = false;
        showError(err);
      });
    });
    card.appendChild(el('div', { class: 'bar' }, [toggle]));

    if (extra) card.appendChild(el('p', { class: 'hint', text: extra }));
    statusBox.appendChild(card);
  }


  // After a save the service starts its insides again: the status goes
  // through "starting" and settles. A 502 from api.cgi on the way is the
  // moment it is not listening, and simply means "ask again".
  //
  // The answer only counts once `since` has changed: until then it comes from
  // the run that is about to stop, which still reports the old state.
  var polling = 0;
  function pollStatus() {
    var before = state.status && state.status.since;
    var round = ++polling, left = 40;
    renderStatus(t('applying'));
    (function next() {
      if (round !== polling) return;
      call('status').then(function (s) {
        var fresh = s.since !== before;
        if (fresh) {
          state.status = s;
          markProblems();
        }
        if ((!fresh || s.state === 'starting') && --left > 0) {
          renderStatus(t('applying'));
          setTimeout(next, 1500);
          return;
        }
        renderStatus();
      }).catch(function () {
        if (--left > 0) setTimeout(next, 1500);
        else renderStatus(t('errUnreachable'));
      });
    })();
  }

  // ---- form ----------------------------------------------------------------

  function field(key, hint, opts) {
    opts = opts || {};
    var s = state.settings;
    var input = el('input', {
      type: opts.secret ? 'password' : 'text',
      id: 'f-' + key,
      value: opts.secret ? '' : (s.values[key] || ''),
      placeholder: opts.placeholder || EXAMPLE[key] || '',
      autocomplete: opts.secret ? 'new-password' : 'off'
    });
    input.dataset.key = key;
    return el('div', { class: 'row', id: 'row-' + key }, [
      el('label', { text: t(LABEL[key]), for: 'f-' + key }),
      input,
      el('span', { class: 'err' }),
      hint ? el('span', { class: 'hint', text: hint }) : null
    ]);
  }

  function secretHint(key, note) {
    return (state.settings.set[key] ? t('secretSet') : t('secretUnset')) + ' ' + note;
  }

  function radio(name, value, current, label, hint) {
    var input = el('input', { type: 'radio', name: name, value: value });
    input.checked = current === value;
    return el('label', { class: 'pick' }, [
      input,
      el('span', {}, [el('span', { text: label }), el('span', { class: 'hint', text: hint })])
    ]);
  }

  // markProblems shows what the service says is wrong next to the field it is
  // about. "Missing" waits until somebody has tried to save: on a fresh
  // package every field is missing, and five red lines greet nobody well.
  function markProblems(extra) {
    Array.prototype.forEach.call(app.querySelectorAll('.row.bad'), function (r) {
      r.classList.remove('bad');
      r.querySelector('.err').textContent = '';
    });
    var list = ((state.status && state.status.problems) || []).slice();
    if (extra) list.push(extra);
    list.forEach(function (p) {
      if (p.code === 'missing' && !state.tried) return;
      var row = document.getElementById('row-' + p.key);
      if (!row) return;
      row.classList.add('bad');
      row.querySelector('.err').textContent = t(PROBLEM[p.code] || 'pMissing');
    });
  }

  function renderForm() {
    var s = state.settings;
    app.textContent = '';

    app.appendChild(el('h2', { text: t('nas') }));
    var checkButton = el('button', { class: 'ghost', text: t('chkBtn') });
    var checkResult = el('div', { class: 'check' });
    checkButton.addEventListener('click', function () { checkAccount(checkButton, checkResult); });
    app.appendChild(el('div', { class: 'card' }, [
      el('p', { class: 'hint', text: t('nasIntro') }),
      field('DSM_USER', t('hDsmUser')),
      field('DSM_PASSWORD', secretHint('DSM_PASSWORD', t('hDsmPassword')), { secret: true }),
      el('div', { class: 'bar' }, [checkButton]),
      checkResult
    ]));

    app.appendChild(el('h2', { text: t('telegram') }));
    app.appendChild(el('div', { class: 'card' }, [
      el('p', { class: 'hint', text: t('telegramIntro') }),
      field('TELEGRAM_BOT_TOKEN', secretHint('TELEGRAM_BOT_TOKEN', t('hBotToken')), {
        secret: true, placeholder: EXAMPLE.TELEGRAM_BOT_TOKEN
      }),
      field('ALLOWED_USER_IDS', t('hAllowedIds'))
    ]));

    app.appendChild(el('h2', { text: t('address') }));
    var chosen = currentAccess();
    var addr = el('div', { class: 'card' }, [
      el('p', { class: 'hint', text: t('addressHint') }),
      el('div', { class: 'access' }, ACCESS.map(function (way) {
        return radio('access', way, chosen, t(ACCESS_TEXT[way][0]), t(ACCESS_TEXT[way][1]));
      })),
      el('div', { id: 'access-steps' }),
      field('PUBLIC_URL', t('hPublicUrl'))
    ]);
    app.appendChild(addr);
    Array.prototype.forEach.call(addr.querySelectorAll('input[name=access]'), function (input) {
      input.addEventListener('change', function () {
        state.accessTouched = true;
        renderAccess();
      });
    });
    renderAccess();

    if (s.notifications) {
      app.appendChild(el('h2', { text: t('notify') }));
      app.appendChild(el('div', { class: 'card' }, [
        el('p', { class: 'hint', text: t('notifyHint') }),
        radio('notify', 'off', s.notifications, t('notifyOff'), t('notifyOffHint')),
        radio('notify', 'downloads', s.notifications, t('notifyDown'), t('notifyDownHint')),
        radio('notify', 'all', s.notifications, t('notifyAll'), t('notifyAllHint'))
      ]));
    }

    // Rarely needed, so folded away: DSM on a port of its own, or the
    // service's port taken by something else.
    var more = el('details', {}, [el('summary', { text: t('advanced') })]);
    more.appendChild(el('div', { class: 'card' }, [
      el('p', { class: 'hint', text: t('advancedHint') }),
      field('DSM_URL', t('hDsmUrl'), { placeholder: s.defaults.DSM_URL }),
      field('LISTEN_ADDR', t('hListen'), { placeholder: s.defaults.LISTEN_ADDR })
    ]));
    app.appendChild(more);

    var save = el('button', { text: t('save') });
    var result = el('span', { class: 'hint' });
    save.addEventListener('click', function () {
      save.disabled = true;
      result.textContent = t('saving');
      state.tried = true;

      var values = {};
      Array.prototype.forEach.call(app.querySelectorAll('input[data-key]'), function (i) {
        values[i.dataset.key] = i.value;
      });
      var picked = app.querySelector('input[name=notify]:checked');

      call('settings', 'PUT', {
        values: values,
        notifications: picked ? picked.value : undefined,
        access: selectedAccess()
      })
        .then(function (saved) {
          state.settings = saved;
          state.accessTouched = false;
          renderForm();
          if (saved.applying) {
            // The outcome shows in the status at the top, and so does Start
            // when the bot is switched off: the button is at the bottom.
            statusBox.scrollIntoView({ block: 'start' });
            pollStatus();
          } else {
            refreshStatus();
            note('good', t('saved'));
          }
        })
        .catch(function (err) {
          save.disabled = false;
          result.textContent = '';
          if (err.field) {
            markProblems({ key: err.field, code: err.code });
            var row = document.getElementById('row-' + err.field);
            if (row) row.scrollIntoView({ block: 'center' });
            return;
          }
          showError(err);
        });
    });
    app.appendChild(el('div', { class: 'bar' }, [save, result]));
    markProblems();
  }

  // ---- account check -------------------------------------------------------

  // The parts the check goes through, in its order. Required ones are what
  // the bot cannot work without; the rest are sections the Mini App shows
  // when DSM lets the account see them.
  var CHECK_LABEL = {
    signin: 'chkSignin', admin: 'chkAdmin', downloads: 'chkDownloads', files: 'chkFiles',
    shares: 'chkShares', details: 'chkDetails', load: 'chkLoad', storage: 'chkStorage',
    vms: 'chkVms', containers: 'chkContainers', log: 'chkLog', notify: 'chkNotify'
  };
  var CHECK_REQUIRED = { signin: true, downloads: true, files: true, shares: true };

  // checkLine says how one part went: a mark and a sentence with what to do.
  function checkLine(item) {
    if (item.state === 'error') return ['off', t('chkError')];
    switch (item.id) {
      case 'signin':
        return item.state === 'ok' ? ['ok', t('chkOk')] : ['bad', authText(item.code)];
      case 'admin':
        return item.state === 'yes' ? ['warn', t('chkAdminYes')] : ['ok', t('chkAdminNo')];
      case 'downloads':
        if (item.state === 'absent') return ['bad', t('chkDownloadsAbsent')];
        return item.state === 'ok' ? ['ok', t('chkOk')] : ['bad', t('chkDownloadsNo')];
      case 'files':
        return item.state === 'ok' ? ['ok', t('chkOk')] : ['bad', t('chkFilesNo')];
      case 'shares':
        return item.state === 'ok'
          ? ['ok', t('chkSharesOk', { count: item.count })] : ['bad', t('chkSharesNone')];
      case 'notify':
        if (item.state === 'absent') return ['off', t('chkAbsent')];
        return item.state === 'ok' ? ['ok', t('chkOk')] : ['off', t('chkNotifyNo', { code: item.code })];
      default:
        if (item.state === 'absent') return ['off', t('chkAbsent')];
        return item.state === 'ok'
          ? ['ok', t('chkOk')] : ['off', t('chkSectionNo', { code: item.code })];
    }
  }

  // The check signs in as whatever is in the two fields — an empty password
  // field means the saved one, which the window never has — and goes through
  // everything the service would do, read-only.
  function checkAccount(button, box) {
    var user = document.getElementById('f-DSM_USER');
    var password = document.getElementById('f-DSM_PASSWORD');
    button.disabled = true;
    box.textContent = '';
    box.appendChild(el('p', { class: 'hint', text: t('chkRunning') }));
    call('check-account', 'POST', {
      user: user ? user.value : '', password: password ? password.value : ''
    }).then(function (res) {
      box.textContent = '';
      var lines = (res.items || []).map(function (item) {
        var line = checkLine(item);
        if (CHECK_REQUIRED[item.id] && line[0] !== 'ok') line[0] = 'bad';
        return { item: item, mark: line[0], text: line[1] };
      });
      var broken = lines.some(function (l) { return l.mark === 'bad'; });
      box.appendChild(el('p', { class: broken ? 'note bad' : 'note good', text: broken ? t('chkNeedsWork') : t('chkReady') }));
      lines.forEach(function (l) {
        box.appendChild(el('div', { class: 'check-line ' + l.mark }, [
          el('span', { class: 'check-mark', text: { ok: '✓', bad: '✗', warn: '!', off: '–' }[l.mark] }),
          el('span', { class: 'check-name', text: t(CHECK_LABEL[l.item.id] || l.item.id) }),
          el('span', { class: 'check-text', text: l.text })
        ]));
      });
    }).catch(function (err) {
      box.textContent = '';
      var text = err && err.status === 400 ? t('chkNeedCreds') : err && err.status === 502 ? t('errUnreachable') : t('errGeneric');
      box.appendChild(el('p', { class: 'note bad', text: text }));
    }).then(function () { button.disabled = false; });
  }

  // ---- Mini App access ------------------------------------------------------

  // The ways the Mini App can be reached, in the order the screen offers
  // them, with a label and a line for each. Only the address matters to the
  // service; the way decides what the screen explains and offers.
  var ACCESS = ['bot', 'ddns', 'domain', 'lan', 'other'];
  var ACCESS_TEXT = {
    bot: ['accBot', 'accBotHint'], ddns: ['accDdns', 'accDdnsHint'], domain: ['accDomain', 'accDomainHint'],
    lan: ['accLan', 'accLanHint'], other: ['accOther', 'accOtherHint']
  };

  function hostOf(url) {
    var m = /^https?:\/\/([^\/:?#]+)/i.exec(url || '');
    return m ? m[1].toLowerCase() : '';
  }

  // The address a rule publishes: https on 443 needs no port in it.
  function ruleURL(r) {
    var def = r.https ? 443 : 80;
    return (r.https ? 'https://' : 'http://') + r.fqdn + (r.port && r.port !== def ? ':' + r.port : '');
  }

  // The way as saved, or — before anybody chose — what the address itself
  // suggests: none means the bot on its own, a DSM DDNS name means DDNS, a
  // reverse proxy rule of DSM's own means a domain, anything else another way.
  function currentAccess() {
    var s = state.settings, a = state.address;
    if (s.access) return s.access;
    var url = s.values.PUBLIC_URL || '';
    if (!url) return 'bot';
    var host = hostOf(url);
    if (a && (a.ddns || []).some(function (d) { return (d.hostname || '').toLowerCase() === host; })) return 'ddns';
    if (!a || (a.matching && a.matching.fqdn === host)) return 'domain';
    return 'other';
  }

  function selectedAccess() {
    var r = app.querySelector('input[name=access]:checked');
    return r ? r.value : currentAccess();
  }

  // When the address data arrives it may tell the guess better — unless the
  // person has already picked something.
  function syncAccess() {
    if (state.accessTouched || state.settings.access) return;
    var want = app.querySelector('input[name=access][value="' + currentAccess() + '"]');
    if (want) want.checked = true;
  }

  // renderAccess shows what the chosen way takes, step by step, and the
  // reverse proxy rule for the ways that go through DSM. The address data is
  // read with the administrator's own session, so it works before the
  // service is set up; until it arrives the steps go without its figures.
  function renderAccess() {
    var box = document.getElementById('access-steps');
    if (!box) return;
    box.textContent = '';
    var way = selectedAccess(), a = state.address;
    var row = document.getElementById('row-PUBLIC_URL');
    if (row) row.hidden = way === 'bot';
    if (way === 'bot') return;

    var lan = a && a.local_ips && a.local_ips.length ? a.local_ips : [];
    var port = (a && a.listen_port) || 58080;
    var target = 'http://localhost:' + port;
    var steps = [];
    if (way === 'ddns') steps.push(t('accStepDdns'));
    if (way === 'domain') steps.push(a && a.external_ip ? t('accStepDomainIp', { ip: a.external_ip }) : t('accStepDomain'));
    if (way === 'ddns' || way === 'domain') {
      steps.push(lan.length ? t('accStepPortsTo', { ip: lan[0] }) : t('accStepPorts'));
      steps.push(t('accStepRule'));
      steps.push(t('accStepCert'));
    }
    if (way === 'lan') {
      steps.push(lan.length ? t('accStepLanDnsIp', { ips: lan.join(', ') }) : t('accStepLanDns'));
      steps.push(t('accStepRule'));
      steps.push(t('accStepLanCert'));
      steps.push(t('accStepVpn'));
    }
    if (way === 'other') {
      steps.push(t('accStepTarget', { target: target }));
      steps.push(t('accStepTargetUrl'));
    }
    box.appendChild(el('ol', { class: 'steps' }, steps.map(function (text) { return el('li', { text: text }); })));

    if (way === 'other') {
      box.appendChild(el('p', { class: 'hint', text: t('accOtherExamples', { target: target, port: port }) }));
      return;
    }
    if (!a) return;
    if (way === 'ddns') {
      var names = (a.ddns || []).map(function (d) { return d.hostname; }).filter(Boolean);
      box.appendChild(el('p', { class: 'hint', text: names.length ? t('addrDdnsNames', { names: names.join(', ') }) : t('addrNoDdns') }));
    }
    renderRule(box, way, a);
  }

  // The reverse proxy rule that sends the name to the service: shown when
  // there is one, created from here when there is not.
  function renderRule(box, way, a) {
    var input = document.getElementById('f-PUBLIC_URL');
    if (a.matching) {
      box.appendChild(el('p', { class: 'note good', text: t('addrMatched') }));
      box.appendChild(kv(ruleURL(a.matching), 'localhost:' + a.matching.backend_port));
      // Coming back to a way that goes through DSM after the address was
      // cleared: the rule is still there, and so is its address.
      if (input && !input.value) input.value = ruleURL(a.matching);
      return;
    }
    var name = el('input', { type: 'text', id: 'fqdn', placeholder: 'nas.example.com' });
    if (way === 'ddns' && a.ddns && a.ddns.length) name.value = a.ddns[0].hostname || '';
    else if (input && input.value) name.value = hostOf(input.value);
    var create = el('button', { class: 'ghost', text: t('addrCreateBtn') });
    create.addEventListener('click', function () {
      create.disabled = true;
      call('address/proxy', 'POST', { fqdn: name.value })
        .then(function (made) {
          // Only the address changes on the page: the other fields may hold
          // what somebody has typed and not saved yet, and re-drawing the
          // form from the server would throw it away.
          state.settings.values.PUBLIC_URL = made.public;
          var urlInput = document.getElementById('f-PUBLIC_URL');
          if (urlInput) urlInput.value = made.public;
          pollStatus();
          return call('address').then(function (next) {
            state.address = next;
            renderAccess();
          });
        })
        .catch(function (err) {
          create.disabled = false;
          showError(err);
        });
    });
    box.appendChild(el('div', { class: 'row' }, [
      el('label', { text: t('addrCreate'), for: 'fqdn' }),
      name,
      el('span', { class: 'hint', text: t('addrFqdnHint') })
    ]));
    box.appendChild(el('div', { class: 'bar' }, [create]));
  }

  function note(kind, text) {
    var box = el('p', { class: 'note ' + kind, text: text });
    app.appendChild(box);
    box.scrollIntoView({ block: 'nearest' });
  }

  function showError(err) {
    var text = t('errGeneric');
    if (err && err.status === 403) text = t('errForbidden');
    else if (err && err.status === 502) text = t('errUnreachable');
    note('bad', text);
  }

  function refreshStatus() {
    return call('status').then(function (s) {
      state.status = s;
      renderStatus();
      markProblems();
    });
  }

  // Status and settings first: they are what the screen is. The address part
  // asks DSM three questions and may be slow or fail on its own; it fills in
  // when it arrives and is simply left out if it does not.
  Promise.all([call('status'), call('settings')]).then(function (r) {
    state.status = r[0];
    state.settings = r[1];
    renderStatus();
    renderForm();
    call('address').then(function (a) {
      state.address = a;
      syncAccess();
      renderAccess();
    }).catch(function () {});
  }).catch(function (err) {
    app.textContent = '';
    showError(err);
  });
})();

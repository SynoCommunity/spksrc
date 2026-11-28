"""Shared context for the tvheadend timeshift checks.

A check receives a Ctx: it carries the connection details, the identifiers it
resolved from the channel name, helpers for the HTTP API and the server log,
and a warm HTSP subscription it keeps so that neighbouring checks do not each
pay for a minute of buffering.
"""
import hashlib
import http.client
import json
import os
import re
import urllib.parse
import subprocess
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import htsp as H                                            # noqa: E402

PASS, FAIL, ABSENT = "pass", "fail", "absent"


class Ctx(object):
    """What a check is handed: where the server is, and what it is made of."""

    def __init__(self, host, user, password, channel,
                 http="9981", htsp=9982, ssh_target="", log_path=""):
        self.host, self.user, self.password = host, user, password
        self.channel_name = channel
        self.http, self.htsp_port = http, int(htsp)
        self.ssh_target, self.log_path = ssh_target, log_path
        self.base = "http://%s:%s/api" % (host, http)
        self.auth = "%s:%s" % (user, password)
        self._digest = None
        self._offset = None
        self._warm = None
        self._warm_sid = 60
        self.start_message = None
        self.chan_id = self.chan_uuid = self.service = self.dvr_config = None
        self.services = []
        self.mux_name = None

    # ---------------------------------------------------------------- HTTP
    def api(self, path, data=None):
        """GET (or POST `data`, "name=value" or a dict of fields) an API path,
        the body back.

        Digest authentication is sent with the request itself.  The usual
        dance -- a first request without credentials, then again on 401 --
        goes wrong on a server whose anonymous access entry grants the right
        asked for: it answers the anonymous request instead of challenging
        it, so the call runs as nobody (and, with curl, with an empty body).
        So the challenge is fetched once from an admin-only path and every
        request is signed with it from the start.
        """
        url = "/api" + path
        body = None
        if isinstance(data, dict):
            # several fields, as the create calls take (class= and conf=)
            body = urllib.parse.urlencode(data) or None
        elif data:
            name, _, value = data.partition("=")
            body = name + "=" + urllib.parse.quote(value, safe="")
        for attempt in (0, 1):
            if self._digest is None or attempt:
                self._digest = self._challenge()
            status, text = self._request("POST" if body else "GET", url, body)
            if status != 401:
                return text
        return text

    def _challenge(self):
        """realm, nonce, opaque of the server's digest challenge."""
        status, headers, _ = self._raw("GET", "/api/status/subscriptions", None, {})
        h = headers.get("www-authenticate", "")
        return {k: v for k, v in re.findall(r'(\w+)="?([^",]*)"?', h)} | {"nc": 0}

    def _request(self, method, url, body):
        d = self._digest
        d["nc"] += 1
        nc = "%08x" % d["nc"]
        cnonce = hashlib.md5(os.urandom(8)).hexdigest()[:16]
        md5 = lambda x: hashlib.md5(x.encode()).hexdigest()      # noqa: E731
        ha1 = md5("%s:%s:%s" % (self.user, d.get("realm", ""), self.password))
        ha2 = md5("%s:%s" % (method, url))
        resp = md5(":".join((ha1, d.get("nonce", ""), nc, cnonce, "auth", ha2)))
        auth = ('Digest username="%s", realm="%s", nonce="%s", uri="%s", qop=auth, '
                'nc=%s, cnonce="%s", response="%s", opaque="%s"'
                % (self.user, d.get("realm", ""), d.get("nonce", ""), url, nc, cnonce,
                   resp, d.get("opaque", "")))
        hdrs = {"Authorization": auth}
        if body is not None:
            hdrs["Content-Type"] = "application/x-www-form-urlencoded"
        status, _, text = self._raw(method, url, body, hdrs)
        return status, text

    def _raw(self, method, url, body, headers):
        conn = http.client.HTTPConnection(self.host, int(self.http), timeout=25)
        try:
            conn.request(method, url, body=body, headers=headers)
            r = conn.getresponse()
            return (r.status, {k.lower(): v for k, v in r.getheaders()},
                    r.read().decode(errors="replace"))
        except (OSError, http.client.HTTPException):
            return (0, {}, "")
        finally:
            conn.close()

    def now(self):
        """The server's clock, in unix seconds.

        Entries are scheduled against it: a server whose clock runs minutes
        ahead of this machine would otherwise take "now + 10 s" for a time
        already past and miss the recording.  Asked once over HTSP
        (getSysTime); tvheadend sends no Date header to read it from.
        """
        if self._offset is None:
            self._offset = 0.0
            try:
                h = self.connect()
                t0 = time.time()
                h.send(method="getSysTime", seq=77)
                r = h.wait("getSysTime", 15, seq=77) if hasattr(h, "wait") else None
                if r and "time" in r:
                    self._offset = r["time"] - (t0 + time.time()) / 2
                h.s.close()
            except Exception:
                pass
        return time.time() + self._offset

    def jload(self, path, data=None):
        try:
            return json.loads(self.api(path, data))
        except Exception:
            return {}

    def save(self, **node):
        return self.api("/idnode/save", "node=" + json.dumps(node))

    # ----------------------------------------------------------------- log
    def log(self, cmd):
        """Run a command against the server log; empty when no ssh was given."""
        if not (self.ssh_target and self.log_path):
            return ""
        try:
            return subprocess.run(["ssh", "-o", "BatchMode=yes", self.ssh_target, cmd],
                                  capture_output=True, timeout=45).stdout.decode().strip()
        except Exception:
            return ""

    def log_mark(self):
        return self.log("wc -l < " + self.log_path)

    def log_since(self, mark, pattern, tail=4):
        return self.log("tail -n +%s %s | grep -aiE '%s' | tail -%d"
                        % (mark, self.log_path, pattern, tail))

    # ---------------------------------------------------------------- HTSP
    def connect(self):
        h = H.Htsp(self.host, self.htsp_port)
        h.login(self.user, self.password)
        H._channels(h)
        return h

    def resolve(self):
        """Find the channel, its service and a DVR configuration to use."""
        h = H.Htsp(self.host, self.htsp_port)
        h.login(self.user, self.password)
        chans = H._channels(h)
        try:
            h.s.close()
        except Exception:
            pass
        self.chan_id = next((k for k, v in chans.items() if v == self.channel_name), None)
        if self.chan_id is None:
            seen = sorted(v for v in chans.values() if v)[:8]
            raise SystemExit("channel %r not found over HTSP; seen: %s"
                             % (self.channel_name, seen))
        for e in self.jload("/channel/grid?limit=1000").get("entries", []):
            if e.get("name") == self.channel_name:
                self.chan_uuid = e.get("uuid")
                svcs = e.get("services") or []
                if svcs:
                    self.service = svcs[0]
                    self.services = list(svcs)
        self.mux_name = self.entry(self.service).get("multiplex") if self.service else None
        cfgs = self.jload("/dvr/config/grid").get("entries", [])
        if cfgs:
            self.dvr_config = cfgs[0].get("uuid")
        if not (self.chan_uuid and self.service and self.dvr_config):
            raise SystemExit("could not resolve channel uuid, service or DVR config")
        return self

    def warm(self, window=70, limit=200):
        """A subscription that has been running, shared by the checks that
        only need somebody watching.

        It waits for the server to actually offer a seek range of `window`
        seconds rather than for a fixed time: how fast the cache fills depends
        on the channel, on what else is watching it, and on whether a service
        restart has just emptied it.  Waiting on the clock instead gave checks
        a ten-second window to rewind forty-five seconds in.
        """
        if self._warm is not None:
            if self._warm.alive():
                return self._warm, self._warm_sid
            # the server dropped it: a new one, warmed like the first
            try:
                self._warm.s.close()
            except OSError:
                pass
            self._warm = None

        self._warm = self.connect()
        # keep the start message: it names the components this service
        # carries, which is the only authority on whether it has video
        self.start_message = H._subscribe(self._warm, self._warm_sid, self.chan_id)
        end = time.time() + limit
        while time.time() < end:
            st = self.pump(self._warm, 10) or {}
            if (st.get("end", 0) - st.get("start", 0)) / 1e6 >= window:
                break
        return self._warm, self._warm_sid

    def drop_warm(self):
        if self._warm is not None:
            try:
                self._warm.send(method="unsubscribe", subscriptionId=self._warm_sid)
                self.pump(self._warm, 3)
                self._warm.s.close()
            except Exception:
                pass
            self._warm = None

    # ------------------------------------------------------------- streams
    @staticmethod
    def pump(h, seconds):
        """Read for a while, returning the last timeshift status seen."""
        end, last = time.time() + seconds, None
        while time.time() < end:
            m = h.recv(3)
            if m and m.get("method") == "timeshiftStatus":
                last = m
        return last

    @staticmethod
    def skip(h, sid, seconds=None, absolute=None):
        if absolute is not None:
            h.send(method="subscriptionSkip", subscriptionId=sid,
                   time=int(absolute), absolute=1)
        else:
            h.send(method="subscriptionSkip", subscriptionId=sid,
                   time=int(seconds * 1000000))
        end = time.time() + 20
        while time.time() < end:
            m = h.recv(3)
            if m and m.get("method") == "subscriptionSkip" \
                    and m.get("subscriptionId") == sid:
                return m
        return None

    @staticmethod
    def position(reply):
        """Seconds the server answered a skip with, or None when it refused."""
        if not reply or reply.get("error"):
            return None
        return reply.get("time", 0) / 1e6

    # --------------------------------------------------------------- caches
    def cache_entry(self):
        """The channel's entry in api/status/caches, or None: the cache of
        whichever of its services is tuned, as a channel can map several (one
        per tuner network) and the cache belongs to the one in use."""
        svcs = set(self.services or [self.service])
        for e in self.jload("/status/caches").get("entries", []):
            if e.get("uuid") in svcs:
                return e
        return None

    # ----------------------------------------------------------------- DVR
    def entry(self, uuid):
        for e in self.jload("/idnode/load?uuid=" + str(uuid)).get("entries", []):
            return {p.get("id"): p.get("value") for p in e.get("params", [])}
        return {}

    def create_entry(self, **conf):
        conf.setdefault("channel", self.chan_uuid)
        conf.setdefault("config_name", self.dvr_config)
        return self.jload("/dvr/entry/create", "conf=" + json.dumps(conf)).get("uuid")

    def drop_entry(self, uuid):
        if not uuid:
            return
        self.api("/dvr/entry/stop", "uuid=" + uuid)
        time.sleep(3)
        self.api("/idnode/delete", "uuid=" + uuid)

    # -------------------------------------------------------- timeshift cfg
    def timeshift(self, **kw):
        """Read the timeshift settings, after changing the ones given."""
        if kw:
            self.api("/timeshift/config/save", "node=" + json.dumps(kw))
        return {p.get("id"): p.get("value")
                for e in self.jload("/timeshift/config/load").get("entries", [])
                for p in e.get("params", [])}

    def recording_running(self):
        """The title of a recording under way on the server, or None: the
        checks that shrink the shared timeshift budget leave it alone then,
        as every cache on the server, the recording's included, draws on it."""
        busy = [s for s in self.subscriptions()
                if (s.get("title") or "").startswith("DVR:")]
        return busy[0].get("title") if busy else None

    def others_watching(self, channel=None):
        """Someone else on the server -- a subscription from another user,
        over the network -- as "client on channel", or None; with `channel`,
        only on that channel."""
        for s in self.subscriptions():
            if not s.get("hostname") or s.get("username") == self.user:
                continue
            if channel and s.get("channel") != channel:
                continue
            return "%s on %s" % (s.get("client") or s.get("username") or s.get("hostname"),
                                 s.get("channel"))
        return None

    def server_in_use(self):
        """Why the server-wide settings are to be left alone -- a recording
        under way, or someone else watching, whose cache draws on the same
        budgets -- or None."""
        busy = self.recording_running()
        if busy:
            return "a recording is running (%s)" % busy
        if getattr(self, "ignore_viewers", False):
            return None     # --ignore-viewers: the operator accepts it
        other = self.others_watching()
        if other:
            return "someone else is watching (%s)" % other
        return None

    def subscriptions(self, mine=False):
        """Subscriptions on the server; with mine, only those on this channel."""
        subs = self.jload("/status/subscriptions").get("entries", [])
        if mine:
            subs = [e for e in subs if e.get("channel") == self.channel_name]
        return subs

    def input_streams(self, mine=False):
        """Inputs that are pulling a stream; with mine, only this channel's mux.
        A server in use is tuned to other channels too, and those are not
        this check's business."""
        ins = [i for i in self.jload("/status/inputs").get("entries", []) if i.get("subs")]
        if mine and self.mux_name:
            ins = [i for i in ins if str(i.get("stream") or "").startswith(self.mux_name)]
        return ins

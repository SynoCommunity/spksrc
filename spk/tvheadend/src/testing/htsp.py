#!/usr/bin/env python3
"""Minimal HTSP client, enough to drive and observe tvheadend timeshift.

Wire format, as src/htsmsg_binary.c writes it:
  field   = type(1) namelen(1) datalen(4 BE) name data
  S64     = little-endian, minimal length
  BOOL    = length 1 when true, 0 when false
  framing = length(4 BE) + fields
"""
import socket, struct, hashlib, sys, time

MAP, S64, STR, BIN, LIST, DBL, BOOL, UUID = 1, 2, 3, 4, 5, 6, 7, 8


def enc_field(name, value):
    nb = name.encode()
    if isinstance(value, bool):
        t, data = BOOL, (b"\x01" if value else b"")
    elif isinstance(value, int):
        t, u, data = S64, abs(value), b""
        if value < 0:                       # two's complement over 8 bytes
            u = (1 << 64) + value
        while u:
            data += bytes([u & 0xFF]); u >>= 8
    elif isinstance(value, str):
        t, data = STR, value.encode()
    elif isinstance(value, bytes):
        t, data = BIN, value
    elif isinstance(value, dict):
        t, data = MAP, enc_fields(value)
    elif isinstance(value, list):
        t, data = LIST, b"".join(enc_field("", v) for v in value)
    else:
        raise TypeError(type(value))
    return bytes([t, len(nb)]) + struct.pack(">I", len(data)) + nb + data


def enc_fields(d):
    return b"".join(enc_field(k, v) for k, v in d.items())


def dec_fields(buf):
    out, i, n = {}, 0, len(buf)
    lst = []
    while i < n:
        t = buf[i]; nl = buf[i + 1]
        dl = struct.unpack(">I", buf[i + 2:i + 6])[0]
        i += 6
        name = buf[i:i + nl].decode("utf-8", "replace"); i += nl
        data = buf[i:i + dl]; i += dl
        if t == S64:
            # as htsmsg_binary.c writes it: the value's bytes, least
            # significant first, as few as hold it read as unsigned -- so
            # only a negative value takes all eight, and only then is the
            # top bit a sign.  Sign-extending a shorter one read 14.9 s
            # (0xE3F996 us) as -1.8 s.
            v = int.from_bytes(data, "little")
            if len(data) == 8 and data[-1] & 0x80:
                v -= 1 << 64
        elif t == STR:
            v = data.decode("utf-8", "replace")
        elif t == BIN:
            v = data
        elif t == BOOL:
            v = bool(dl)
        elif t in (MAP, LIST):
            v = dec_fields(data)
        else:
            v = data
        if name:
            out[name] = v
        else:
            lst.append(v)
    return lst if (lst and not out) else out


class Htsp:
    def __init__(self, host, port=9982):
        self.s = socket.create_connection((host, port), timeout=20)
        self.buf = b""
        self.closed = False

    def send(self, **kw):
        body = enc_fields(kw)
        self.s.sendall(struct.pack(">I", len(body)) + body)

    def recv(self, timeout=20):
        self.s.settimeout(timeout)
        try:
            return self._recv()
        except (socket.timeout, TimeoutError):
            return None

    def _recv(self):
        while len(self.buf) < 4:
            d = self.s.recv(65536)
            if not d:
                self.closed = True
                return None
            self.buf += d
        ln = struct.unpack(">I", self.buf[:4])[0]
        while len(self.buf) < 4 + ln:
            d = self.s.recv(65536)
            if not d:
                self.closed = True
                return None
            self.buf += d
        msg, self.buf = self.buf[4:4 + ln], self.buf[4 + ln:]
        return dec_fields(msg)

    def alive(self, timeout=10):
        """Whether the server still answers on this connection.  It drops a
        client that leaves its socket full long enough ("Write error --
        Resource temporarily unavailable"), as a check that keeps a connection
        while it does something else for a minute does."""
        if self.closed:
            return False
        try:
            self.send(method="getSysTime")
            end = time.time() + timeout
            while time.time() < end and not self.closed:
                m = self.recv(1)
                if m and "method" not in m and "time" in m:
                    return True
        except OSError:
            self.closed = True
        return False

    def wait(self, method, timeout=20, seq=None):
        """Wait for a message by method, or by sequence number."""
        end = time.time() + timeout
        while time.time() < end:
            m = self.recv(max(1, end - time.time()))
            if m is None:
                return None
            if seq is not None and m.get("seq") == seq:
                return m
            if method and m.get("method") == method:
                return m
        return None

    def login(self, user, password, version=36):
        self.send(method="hello", htspversion=version,
                  clientname="claude-htsp-test", clientversion="1.0")
        r = self.recv()
        ch = r.get("challenge")
        self.version = r.get("htspversion")
        d = hashlib.sha1(password.encode() + ch).digest()
        self.send(method="authenticate", username=user, digest=d, seq=1)
        a = self.wait(None, seq=1)
        return self.version, a


# ------------------------------------------------------------ helpers

def _channels(h, timeout=25):
    """enableAsyncMetadata, then collect channelAdd until the initial sync ends."""
    h.send(method="enableAsyncMetadata", seq=2)
    chans, end = {}, time.time() + timeout
    while time.time() < end:
        m = h.recv(max(1, end - time.time()))
        if m is None:
            break
        meth = m.get("method")
        if meth == "channelAdd":
            chans[m.get("channelId")] = m.get("channelName")
        elif meth == "initialSyncCompleted":
            break
    return chans


def _subscribe(h, sid, chid, period=3600, timeout=25):
    """Subscribe with timeshift; return the subscriptionStart, or the failing status."""
    h.send(method="subscribe", channelId=chid, subscriptionId=sid,
           timeshiftPeriod=period, normts=1, queueDepth=500000)
    end = time.time() + timeout
    started = None
    while time.time() < end:
        m = h.recv(max(1, end - time.time()))
        if m is None:
            break
        meth = m.get("method")
        if meth == "subscriptionStart" and m.get("subscriptionId") == sid:
            started = m
            break
        if meth == "subscriptionStatus" and m.get("subscriptionId") == sid and m.get("status"):
            return {"error": m.get("status")}
    return started


def _skip(h, sid, seconds, timeout=25):
    """Relative subscriptionSkip; return {'error': 1} or {'time': us}."""
    h.send(method="subscriptionSkip", subscriptionId=sid,
           time=int(seconds * 1000000))
    end = time.time() + timeout
    while time.time() < end:
        m = h.recv(max(1, end - time.time()))
        if m is None:
            break
        if m.get("method") == "subscriptionSkip" and m.get("subscriptionId") == sid:
            return m
    return None


def _timeshift_status(h, sid, timeout=12):
    end = time.time() + timeout
    while time.time() < end:
        m = h.recv(max(1, end - time.time()))
        if m is None:
            break
        if m.get("method") == "timeshiftStatus" and m.get("subscriptionId") == sid:
            return m
    return None


if __name__ == "__main__":
    # try it: python3 htsp.py <host> <user> <password>
    host = sys.argv[1] if len(sys.argv) > 1 else "127.0.0.1"
    user = sys.argv[2] if len(sys.argv) > 2 else ""
    pw = sys.argv[3] if len(sys.argv) > 3 else ""
    h = Htsp(host)
    v, a = h.login(user, pw)
    print("server HTSP version:", v)
    print("authentication:", "refused" if a.get("noaccess") else "accepted",
          {k: a[k] for k in ("streaming", "dvr", "admin") if k in a})

#!/usr/local/subliminal/env/bin/python
from pyextdirect.router import Router
import cgi
from api import Base


if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    router = Router(Base)
    fs = cgi.FieldStorage()
    request = fs.value
    if isinstance(fs.value, list):
        request = dict((k, fs.getvalue(k)) for k in fs.keys())
    print router.route(request)

#!/usr/local/debian-chroot/env/bin/python
from pyextdirect.router import Router
import cgi
from api import Base



if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    router = Router(Base)
    fs = cgi.FieldStorage()
    request = fs.value
    if isinstance(request, list):
        request = dict((mfs.name, mfs.value) for mfs in request)
    print router.route(request)

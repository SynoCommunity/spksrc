#!/usr/local/python/bin/python

cpDir = ('/usr/local/lazylibrarian/')

from os import path, environ
from ConfigParser import RawConfigParser
cpCfg = RawConfigParser ()
cpCfg.add_section ('General')
cpCfg.set ('General', 'http_port', '5299')
cpCfg.read (cpDir + 'config.ini')
host = environ['HTTP_HOST'].split (':')[0]
response = 'Location: http://%s:%s/\n' % (host, cpCfg.get ('General', 'http_port'))
print (response)

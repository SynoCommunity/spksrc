#!/usr/local/python/bin/python

cpDir = ('/usr/local/gamez/')

from os import path, environ
from ConfigParser import RawConfigParser
cpCfg = RawConfigParser ()
cpCfg.add_section ('global')
cpCfg.set ('global', 'gamez_port', '5290')
cpCfg.read (cpDir + 'Gamez.ini')
host = environ['HTTP_HOST'].split (':')[0]
response = 'Location: http://%s:%s/\n' % (host, cpCfg.get ('global', 'gamez_port'))
print (response)

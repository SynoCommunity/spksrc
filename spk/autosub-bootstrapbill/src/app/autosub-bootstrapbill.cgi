#!/usr/local/python/bin/python

cpDir = ('/usr/local/autosub-bootstrapbill/')

from os import path, environ
from ConfigParser import RawConfigParser
cpCfg = RawConfigParser ()
cpCfg.add_section ('webserver')
cpCfg.set ('webserver', 'webserverport', '@PORT@')
cpCfg.read (cpDir + 'config.properties')
host = environ['HTTP_HOST'].split (':')[0]
response = 'Location: http://%s:%s/\n' % (host, cpCfg.get ('webserver', 'webserverport'))
print (response)

#!/usr/local/couchpotato/env/bin/python
import os
import ConfigParser


config = ConfigParser.ConfigParser()
config.read('/usr/local/couchpotato/var/config.ini')
protocol = 'http'
port = int(config.get('core', 'port'))

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

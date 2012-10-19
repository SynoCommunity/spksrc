#!/usr/local/gateone/env/bin/python
import os
import ConfigParser


config = ConfigParser.ConfigParser()
config.read('/usr/local/gateone/var/server.conf')
protocol = 'http' if config.getboolean('DEFAULT', 'disable_ssl') else 'https'
port = config.getint('DEFAULT', 'port')

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

#!/usr/local/mylar/env/bin/python
import os
import ConfigParser


config = ConfigParser.SafeConfigParser()
config.read('/usr/local/mylar/var/config.ini')
protocol = 'http'
port = int(config.get('General', 'http_port'))

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

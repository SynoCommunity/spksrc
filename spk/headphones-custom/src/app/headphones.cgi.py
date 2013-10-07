#!/usr/local/headphones-custom/env/bin/python
import os
import ConfigParser


config = ConfigParser.SafeConfigParser()
config.read('/usr/local/headphones-custom/var/config.ini')
protocol = 'http'
port = int(config.get('General', 'http_port'))

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

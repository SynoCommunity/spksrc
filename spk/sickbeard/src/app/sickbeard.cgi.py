#!/usr/local/sickbeard/env/bin/python
import os
import ConfigParser


config = ConfigParser.SafeConfigParser()
config.read('/usr/local/sickbeard/var/config.ini')
protocol = 'https' if int(config.get('General', 'enable_https')) else 'http'
port = int(config.get('General', 'web_port'))

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

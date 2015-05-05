#!/usr/local/python/bin/python

import os
import ConfigParser

config = ConfigParser.ConfigParser()
config.read('/usr/local/xdm/config.ini')
port = int(config.get('webconfig', 'port'))
protocol = 'https' if (config.get('webconfig', 'enable_ssl') == 'yes') else 'http'

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

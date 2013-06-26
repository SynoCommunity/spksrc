#!/usr/local/synodlnatrakt/env/bin/python
import os
import configobj

config = configobj.ConfigObj('/usr/local/synodlnatrakt/var/config.ini')
protocol = 'http'
port = int(config['Advanced']['port'])

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

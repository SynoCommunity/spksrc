#!/usr/local/gateone/env/bin/python
import os
import configobj


config = configobj.ConfigObj('/usr/local/gateone/var/server.conf')
protocol = 'http' if config.as_bool('disable_ssl') else 'https'
port = config.as_int('port')

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

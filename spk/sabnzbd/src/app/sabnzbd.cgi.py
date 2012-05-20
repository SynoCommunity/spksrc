#!/usr/local/sabnzbd/env/bin/python
import os
import configobj


config = configobj.ConfigObj('/usr/local/sabnzbd/var/config.ini')
protocol = 'https' if int(config['misc']['enable_https']) else 'http'
port = int(config['misc']['https_port']) if int(config['misc']['enable_https']) else int(config['misc']['port'])

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

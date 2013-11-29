#!/usr/local/sabnzbd/env/bin/python
import os
import configobj


config = configobj.ConfigObj('/var/services/homes/oscam/config.ini')
protocol = 'https' if int(config['misc']['enable_https']) else 'http'
https_port = int(config['misc']['port']) if len(config['misc']['https_port']) == 0 else int(config['misc']['https_port'])
port = https_port if protocol == 'https' else int(config['misc']['port'])

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

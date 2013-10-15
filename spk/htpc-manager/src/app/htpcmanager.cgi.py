#!/usr/local/htpcmanager/env/bin/python

import sqlite3
import os

conn = sqlite3.connect('/usr/local/htpcmanager/var/database.db')

settings = dict()

c = conn.cursor()
for row in c.execute('SELECT * from setting'):
  settings[row[1]] = row[2]

if not settings:
    settings['app_port'] = 8085
    settings['app_webdir'] = '/'
    protocol = 'http'
else:
    if settings['app_ssl_key'] != '':
      protocol = 'https'
    else:
      protocol = 'http'

print 'Location: %s://%s:%d%s' % (protocol, os.environ['SERVER_NAME'], int(settings['app_port']), settings['app_webdir'])
print


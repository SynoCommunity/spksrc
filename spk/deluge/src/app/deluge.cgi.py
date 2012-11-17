#!/usr/local/deluge/env/bin/python
import os


protocol = 'http'
port = 8112

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

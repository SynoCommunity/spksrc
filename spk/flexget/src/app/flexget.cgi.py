#!/usr/local/flexget/env/bin/python
import os


protocol = 'http'
port = 8290

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

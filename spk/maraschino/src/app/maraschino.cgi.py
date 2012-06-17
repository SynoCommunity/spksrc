#!/usr/local/maraschino/env/bin/python
import os


protocol = 'http'
port = 8260

print 'Location: %s://%s:%d' % (protocol, os.environ['SERVER_NAME'], port)
print

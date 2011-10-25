#!/usr/local/python26/bin/python

dir = '/usr/local/var/headphones/'
try :
    pid  = int (open (dir  + 'headphones.pid', 'rt').readline ())
except IOError, ValueError :
    pass
else :
    from os import path, environ
    if path.isdir ('/proc/%d' % pid) :
        from ConfigParser import RawConfigParser
        cfg = RawConfigParser ()
        cfg.add_section ('General')
        cfg.set ('General', 'http_port', '8181')
        cfg.read (dir + 'config.ini')
        host = environ['HTTP_HOST'].split (':')[0]
        response = 'Location: http://%s:%s/\n' % (host, cfg.get ('General', 'http_port'))
        print (response)

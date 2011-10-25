#!/usr/local/python26/bin/python

cpDir = '/usr/local/var/couchpotato/'
try :
    pid  = int (open (cpDir  + 'couchpotato.pid', 'rt').readline ())
except IOError, ValueError :
    pass
else :
    from os import path, environ
    if path.isdir ('/proc/%d' % pid) :
        from ConfigParser import RawConfigParser
        cpCfg = RawConfigParser ()
        cpCfg.add_section ('global')
        cpCfg.set ('global', 'port', '5000')
        cpCfg.read (cpDir + 'config.ini')
        host = environ['HTTP_HOST'].split (':')[0]
        response = 'Location: http://%s:%s/\n' % (host, cpCfg.get ('global', 'port'))
        print (response)

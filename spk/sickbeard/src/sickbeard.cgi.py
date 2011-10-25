#!/usr/local/python26/bin/python

sbDir = '/usr/local/var/sickbeard/'
try :
    pid  = int (open (sbDir  + 'sickbeard.pid', 'rt').readline ())
except IOError, ValueError :
    pass
else :
    from os import path, environ
    if path.isdir ('/proc/%d' % pid) :
        from ConfigParser import RawConfigParser
        sbCfg = RawConfigParser ()
        sbCfg.add_section ('General')
        sbCfg.set ('General', 'web_port', '8081')
        sbCfg.read (sbDir  + 'config.ini')
        host = environ['HTTP_HOST'].split (':')[0]
        response = 'Location: http://%s:%s/\n' % (host, sbCfg.get ('General', 'web_port'))
        print (response)

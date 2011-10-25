#!/usr/local/python26/bin/python

from sys import path, argv, stdout, exit
import os.path

stdout.write ('[General]\n')
stdout.write ('launch_browser = 0\n')

path.append ('/usr/local/sabnzbd/share/SABnzbd/sabnzbd/utils')
try :
    from configobj import ConfigObj
except ImportError :
    pass # SABnzbd is not installed, nothing more to do.
else :
    sabCfg = ConfigObj (argv[1])
    miscCfg = sabCfg ['misc']
    
    stdout.write ('\n')
    stdout.write ('[SABnzbd]\n')
    stdout.write ('sab_host = http://localhost:%s\n' % miscCfg['port'])
    stdout.write ('sab_username = %s\n' % miscCfg['username'])
    stdout.write ('sab_password = %s\n' % miscCfg['password'])
    stdout.write ('sab_apikey = %s\n' % miscCfg['api_key'])
    musicCatCfg = sabCfg['categories']['music']
    stdout.write ('sab_category = %s\n' % musicCatCfg['name'])

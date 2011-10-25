#!/usr/local/python26/bin/python

from sys import path, argv, stdout, exit
import os.path

stdout.write ('[global]\n')
stdout.write ('port = 8082\n')
stdout.write ('launchbrowser = False\n')

path.append ('/usr/local/sabnzbd/share/SABnzbd/sabnzbd/utils')
try :
    from configobj import ConfigObj
except ImportError :
    pass # SABnzbd is not installed, nothing more to do.
else :
    sabCfg = ConfigObj (argv[1])
    miscCfg = sabCfg ['misc']
    
    stdout.write ('\n')
    stdout.write ('[Sabnzbd]\n')
    stdout.write ('host = localhost:%s\n' % miscCfg['port'])
    stdout.write ('username = %s\n' % miscCfg['username'])
    stdout.write ('password = %s\n' % miscCfg['password'])
    stdout.write ('apikey = %s\n' % miscCfg['api_key'])
    movieCatCfg = sabCfg['categories']['movies']
    stdout.write ('category = %s\n' % movieCatCfg['name'])

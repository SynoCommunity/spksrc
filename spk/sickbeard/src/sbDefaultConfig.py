#!/usr/local/sabnzbd/bin/python

from sys import path, argv, stdout, exit
import os.path

stdout.write ('[General]\n')
stdout.write ('web_port = 9300\n')
stdout.write ('web_host = 0.0.0.0\n')
stdout.write ('use_nzbs = 1\n')
stdout.write ('launch_browser = 0\n')

path.append ('/usr/local/sabnzbd/share/SABnzbd/sabnzbd/utils')
try :
    from configobj import ConfigObj
except ImportError :
    pass
else :
    sabCfg = ConfigObj (argv[1])
    miscCfg = sabCfg ['misc']
    tvCatCfg = sabCfg['categories']['tv']

    dir = tvCatCfg['dir']
    if not os.path.isabs (dir) :
        dir = os.path.join (miscCfg['complete_dir'], dir)

    stdout.write ('tv_download_dir = %s\n' % dir)
    stdout.write ('nzb_method = sabnzbd\n')
    stdout.write ('\n')
    stdout.write ('[SABnzbd]\n')
    stdout.write ('sab_username = "%s"\n' % miscCfg['username'])
    stdout.write ('sab_password = "%s"\n' % miscCfg['password'])
    stdout.write ('sab_apikey = "%s"\n' % miscCfg['api_key'])
    stdout.write ('sab_category = %s\n' % tvCatCfg['name'])
    stdout.write ('sab_host = localhost:%s\n' % miscCfg['port'])

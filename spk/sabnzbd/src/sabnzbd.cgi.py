#!/usr/local/python27/bin/python

from sys import path as syspath
from subprocess import check_call, CalledProcessError
from os import environ, devnull

syspath.append ('/usr/local/sabnzbd/share/SABnzbd/sabnzbd/utils')
from configobj import ConfigObj
miscCfg = ConfigObj ('/usr/local/var/sabnzbd/config.ini')['misc']

try :
    port=miscCfg['port']
except KeyError:
    port='8080'

wgetArgs = ['wget', '-q', '--spider']
try :
    wgetArgs.append ('--user=%s' % miscCfg['username'])
except KeyError :
    pass
try :
    wgetArgs.append ('--password=%s' % miscCfg['password'])
except KeyError :
    pass
wgetArgs.append ('http://localhost:%s/' % port)

try :
    check_call (wgetArgs, stdout=open (devnull))
except CalledProcessError :
    pass
else :
    host=environ['HTTP_HOST'].split (':')[0]
    response='Location: http://%s:%s/\n' % (host, port)
    print (response)

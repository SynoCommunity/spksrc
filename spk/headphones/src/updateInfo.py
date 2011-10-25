#!/usr/local/python26/bin/python

from os import stat, rename

info = '/var/packages/Headphones/INFO'
hpCfgFile = '/usr/local/var/headphones/config.ini'

if stat(info).st_mtime < stat(hpCfgFile).st_mtime : 
    from ConfigParser import RawConfigParser
    hpCfg = RawConfigParser ()
    hpCfg.read (hpCfgFile)
    old = open (info, 'rt')
    newInfo = '%s-tmp' % info
    new = open (newInfo, 'wt')
    for line in old :
        if line.startswith ('adminport') :
            new.write ('adminport=%s\n' % hpCfg.get ('General', 'http_port'))
        else :
            new.write (line)
    new.close ()
    old.close ()
    rename (newInfo, info)

#!/usr/local/python26/bin/python

from os import stat, rename

info = '/var/packages/SickBeard/INFO'
sbCfgFile = '/usr/local/var/sickbeard/config.ini'

if stat(info).st_mtime < stat(sbCfgFile).st_mtime : 
    from ConfigParser import RawConfigParser
    sbCfg = RawConfigParser ()
    sbCfg.read (sbCfgFile)
    old = open (info, 'rt')
    newInfo = '%s-tmp' % info
    new = open (newInfo, 'wt')
    for line in old :
        if line.startswith ('adminport') :
            new.write ('adminport=%s\n' % sbCfg.get('General', 'web_port'))
        else :
            new.write (line)
    new.close ()
    old.close ()
    rename (newInfo, info)

#!/usr/local/python26/bin/python

from os import stat, rename

info = '/var/packages/CouchPotato/INFO'
cpCfgFile = '/usr/local/var/couchpotato/config.ini'

if stat(info).st_mtime < stat(cpCfgFile).st_mtime : 
    from ConfigParser import RawConfigParser
    cpCfg = RawConfigParser ()
    cpCfg.read (cpCfgFile)
    old = open (info, 'rt')
    newInfo = '%s-tmp' % info
    new = open (newInfo, 'wt')
    for line in old :
        if line.startswith ('adminport') :
            new.write ('adminport=%s\n' % cpCfg.get ('global', 'port'))
        else :
            new.write (line)
    new.close ()
    old.close ()
    rename (newInfo, info)

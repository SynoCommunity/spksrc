#!/usr/local/python26/bin/python

from os import stat, rename

info = '/var/packages/SABnzbd/INFO'
cfgFile = '/usr/local/var/sabnzbd/config.ini'

if stat(info).st_mtime < stat(cfgFile).st_mtime :
    from sys import path
    path.append ('/usr/local/sabnzbd/share/SABnzbd/sabnzbd/utils')
    from configobj import ConfigObj
    cfg = ConfigObj (cfgFile)
    old = open (info, 'rt')
    newInfo = '%s-tmp' % info
    new = open (newInfo, 'wt')
    for line in old :
        if line.startswith ('adminport') :
            new.write ('adminport=%s\n' % cfg['misc']['port'])
        else :
            new.write (line)
    new.close ()
    old.close ()
    rename (newInfo, info)

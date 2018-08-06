#!/usr/bin/python
import os
import sys
import time
import logging
import subprocess
from lockfile import locked
from logging.handlers import RotatingFileHandler

INSTALL_DIR = '/usr/local/iOSAccess'
VOLUME_DIR = os.path.join(INSTALL_DIR, 'volume')
LOGFILE = os.path.join(INSTALL_DIR, 'var/log/access.log')
LOCKFILE = os.path.join(INSTALL_DIR, 'var/run/access.lock')

logger = logging.getLogger('Rotating Log')
logger.setLevel(logging.INFO)
handler = RotatingFileHandler(LOGFILE, maxBytes=102400, backupCount=5)
logger.addHandler(handler)


def run(cmd):
    global logger
    try:
        p = subprocess.Popen(
            cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate()
        logger.info('subprocess.call {%s}' % cmd)
        logger.info('return code: %d' % p.returncode)
        logger.info('stdout: %s' % out)
        logger.info('stderr: %s' % err)
        return p.returncode
    except Exception as e:
        logger.error('exception: %s' % e.message)
    return -1


def notify(message):
    return run('/usr/syno/bin/synodsmnotify @users iOSAccess "%s"' % message)


def add_share(name, path):
    return run(
        '/usr/syno/sbin/synoshare --add %s "iOS Access" %s "" "" "@users" 1 0'
        % (name, path))


def del_share(path):
    return run(
        '/usr/syno/sbin/synoshare -del TRUE %s' % os.path.basename(path))


def ifuse_mount(path):
    return run('/usr/local/bin/ifuse -o nonempty -o allow_other %s' % path)


def umount(path):
    return run('/bin/umount %s' % path)

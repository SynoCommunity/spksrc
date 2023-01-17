#!/usr/bin/python

"""
Copyright (c) 2018 BingJing Chang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

import os
import sys
import time
import logging
import subprocess
from lockfile import locked
from logging.handlers import RotatingFileHandler

INSTALL_DIR = '/usr/local/itools'
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
    return run('/usr/syno/bin/synodsmnotify @users iOS "%s"' % message)


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

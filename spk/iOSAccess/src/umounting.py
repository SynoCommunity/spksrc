#!/usr/bin/python
import os
import sys
import time
import logging
from lockfile import locked
from logging.handlers import RotatingFileHandler
from common import *


@locked(LOCKFILE)
def main():
    if os.fork() != 0:
        sys.exit()
    time.sleep(3)
    output = os.popen('mount').read()
    for line in filter(lambda x: x.find('ifuse') == 0, output.split('\n')):
        path = line.split()[2]
        logger.info('Unmounting %s ...' % path)
        umount(path)
        logger.info('Deleting DSM share named %s...' % os.path.basename(path))
        del_share(path)

if __name__ == '__main__':
    logger.info('--- umounting.py started ---')
    try:
        main()
    except Exception as e:
        logger.error(str(e))
    logger.info('--- umounting.py end ---')

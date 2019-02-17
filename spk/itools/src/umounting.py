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

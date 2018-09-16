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
    time.sleep(3)
    for i in xrange(12):
        output = os.popen('ideviceinfo | grep DeviceName').read()
        if output.find('DeviceName: ') == 0:
            break
        if i == 1:
            notify('An iOS device is plugged. Wait for device agreement.')
        logger.error(
            'Could not get device info. ' +
            "Maybe it's prompting user agreement." +
            'Sleep 5 seconds. Try Count: (%d/12)' % (i + 1, 12))
        time.sleep(5)

    if output.find('DeviceName: ') != 0:
        logger.error('Failed to get device info!')
        return

    device_name = output.split(' ')[1].strip()
    mount_dir = os.path.join(VOLUME_DIR, device_name)
    output = os.popen('mount | grep %s' % device_name).read().strip()
    if len(output) > 0:
        logger.error('%s is already mounted! (%s)' % (device_name, output))
        return

    output = os.popen(
        'synoshare --get %s | grep Comment' % device_name).read().strip()
    if output.find('Comment') >= 0:
        logger.info('Share - %s exists. (%s)' % (device_name, output))
        if output.find('iOS Access') < 0:
            logger.error('Share - %s is not created by this package!')
            return
    else:
        logger.info('Creating a DSM share - %s for it...' % device_name)
        if add_share(device_name, mount_dir) < 0:
            logger.error('Failed to create DSM share - %s!' % device_name)
            return

    logger.info('Mounting iOS directory into %s...' % mount_dir)
    if ifuse_mount(mount_dir) < 0:
        logger.error('Failed to mount iOS directory. Cleaning up...')
        logger.info('Deleting DSM share named %s...' % device_name)
        del_share(device_name)
        return

    # magic: we have to enter the folder first time
    os.system('cd %s && ls' % mount_dir)
    notify('%s is ready to be access in FileStation.' % device_name)

if __name__ == '__main__':
    logger.info('--- mounting.py started ---')
    try:
        main()
    except Exception as e:
        logger.error(str(e))
    logger.info('--- mounting.py end ---')

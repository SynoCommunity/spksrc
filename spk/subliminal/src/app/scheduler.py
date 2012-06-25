#!/usr/local/subliminal/env/bin/python
# -*- coding: utf-8 -*-
from api import Subliminal
from datetime import datetime, timedelta
import time
import os
import atexit
import signal
import sys
import logging
import logging.handlers


logger = logging.getLogger()


class CronTab(object):
    def __init__(self, pidfile):
        self.pidfile = pidfile
        self.subliminal = Subliminal()
        self.running = False

    def daemonize(self):
        """Do the UNIX double-fork magic, see Stevens' "Advanced
        Programming in the UNIX Environment" for details (ISBN 0201563177)
        http://www.erlenstar.demon.co.uk/unix/faq_2.html#SEC16

        """
        try:
            pid = os.fork()
            if pid > 0:  # exit first parent
                sys.exit(0)
        except OSError, e:
            sys.stderr.write('Fork #1 failed: %d (%s)\n' % (e.errno, e.strerror))
            sys.exit(1)

        # decouple from parent environment
        os.chdir('/')
        os.setsid()
        os.umask(0)

        # do second fork
        try:
            pid = os.fork()
            if pid > 0:  # exit from second parent
                sys.exit(0)
        except OSError, e:
            sys.stderr.write('Fork #2 failed: %d (%s)\n' % (e.errno, e.strerror))
            sys.exit(1)

        # write pidfile
        atexit.register(self.delpid)
        file(self.pidfile, 'w+').write('%s\n' % str(os.getpid()))

    def delpid(self):
        if os.path.exists(self.pidfile):
            os.remove(self.pidfile)
    
    def start(self):
        """Start the application and daemonize"""
        logger.info(u'Starting')
        file(self.pidfile, 'w+').write('%s\n' % str(os.getpid()))
        self.daemonize()
        self.run()

    def stop(self):
        """Stop the application"""
        logger.info(u'Stopping')
        self.running = False

    def run(self):
        self.running = True

        # Plug signals
        signal.signal(signal.SIGINT, self.signal_handler)
        signal.signal(signal.SIGTERM, self.signal_handler)

        # Run the scan
        t = datetime(*datetime.now().timetuple()[:5])
        while self.running:
            self.subliminal.config.reload()
            self.subliminal.config.validate(self.subliminal.config_validator)
            if self.subliminal.config['Task']['enable'] and self.subliminal.config['Task']['hour'] == t.hour and self.subliminal.config['Task']['minute'] == t.minute:
                logger.info(u'Running scan')
                try:
                    self.subliminal.scan()
                except Exception as e:
                    logger.fatal(u'Scan failed: %s' % e)
            t += timedelta(minutes=1)
            while self.running and datetime.now() < t:
                time.sleep(min((t - datetime.now()).seconds + 1, 10))

    def signal_handler(self, *args):
        self.stop()
        exit(0)


def initLogging(logfile):
    root = logging.getLogger()
    root.setLevel(logging.INFO)
    handler = logging.handlers.RotatingFileHandler(logfile, maxBytes=2097152, backupCount=3, encoding='utf-8')
    handler.setFormatter(logging.Formatter('%(asctime)s:%(levelname)s:%(name)s:%(message)s', datefmt='%m/%d/%Y %H:%M:%S'))
    root.handlers = [handler]


if __name__ == '__main__':
    pidfile = '/usr/local/subliminal/var/scheduler.pid'
    logfile = '/usr/local/subliminal/var/scheduler.log'
    if os.path.exists(pidfile):
        exit(1)
    initLogging(logfile)
    crontab = CronTab(pidfile)
    crontab.start()

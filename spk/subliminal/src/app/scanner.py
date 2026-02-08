#!/usr/local/subliminal/env/bin/python
from application.db import Session, Directory
from application.direct import Subliminal, scan, notify
import os
import sys
import argparse


class Scanner(object):
    def __init__(self, directory_id):
        self.directory_id = directory_id
        self.session = Session()

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
    
    def start(self):
        """Start the application and daemonize"""
        self.daemonize()
        self.run()

    def run(self):
        directory = self.session.query(Directory).get(self.directory_id)
        if not os.path.exists(directory.path):
            return 0
        s = Subliminal()
        results = scan(directory.path, s.config, temp_cache=True)
        if s.config['General']['dsm_notifications']:
            notify('Downloaded %d subtitle(s) for %d video(s) in directory %s' % (sum([len(s) for s in results.itervalues()]), len(results), directory.name))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Directory scanner')
    parser.add_argument('id', help='directory id to scan', metavar='ID')
    args = parser.parse_args()
    scanner = Scanner(args.id)
    scanner.start()

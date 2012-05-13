#!/usr/local/debian-chroot/env/bin/python
import json
from api import Overview


if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    overview = Overview()
    event = {'type': 'event', 'name': 'status', 'data': {
                 'installed': 'installed' if overview.is_installed() else 'installing',
                 'running_services': overview.running_services()}}
    print json.dumps(event)

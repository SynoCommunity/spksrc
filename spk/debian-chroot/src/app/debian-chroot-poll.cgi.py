#!/usr/local/debian-chroot/env/bin/python
import os
import db


if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    session = db.Session()
    event = {'type': 'event', 'name': 'status', 'data': {
        'installed': 'installed' if os.path.exists('/usr/local/debian-chroot/var/installed') else 'installing',
        'running_services': len([service for service in session.query(db.Service).all() if service.status == 1])}}
    json.dumps(event)


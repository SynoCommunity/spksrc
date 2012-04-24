#!/usr/local/debian-chroot/env/bin/python
import os
import cgi
from pyextdirect.configuration import create_configuration, expose, STORE_READ
from pyextdirect.router import Router
import db


Base = create_configuration()


class Services(Base):
    def __init__(self):
        self.session = db.Session()

    @expose(kind=STORE_READ)
    def load(self):
        services = []
        for service in self.session.query(db.Service).all():
            services.append({'id': service.id, 'name': service.name, 'launch_script': service.launch_script,
                             'status_command': service.status_command, 'status': service.status})
        return services

    @expose
    def save(self, *args, **kwargs):
        pass

    @expose
    def start(self, service_id):
        service = self.session.query(db.Service).get(service_id)
        service.start()

    @expose
    def stop(self, service_id):
        service = self.session.query(db.Service).get(service_id)
        service.stop()


if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    router = Router(Base)
    router.debug = True
    fs = cgi.FieldStorage()
    request = fs.value
    if isinstance(request, list):
        request = dict((mfs.name, mfs.value) for mfs in request)
    print router.route(request)

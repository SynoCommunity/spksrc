# -*- coding: utf-8 -*-
from db import *
from pyextdirect.configuration import (create_configuration, expose, LOAD,
    STORE_READ, STORE_CUD)
from sqlalchemy.orm import joinedload
import os
import pwd
import shutil
import subprocess


__all__ = ['Base', 'Configuration', 'Frontends', 'Backends', 'Associations']


Base = create_configuration()


class Configuration(Base):
    path = u'/usr/local/haproxy/var/haproxy.cfg'
    template = u'/usr/local/haproxy/var/haproxy.cfg.tpl'
    start_stop_status = u'/var/packages/haproxy/scripts/start-stop-status'
    crt_path = u'/usr/local/haproxy/var/crt/default.pem'
    user = u'sc-haproxy'

    def __init__(self):
        self.session = Session()

    @expose(kind=LOAD)
    def load(self):
        return {'status': self.status(), 'frontends': self.session.query(Frontend).count(),
                'backends': self.session.query(Backend).count(), 'associations': self.session.query(Association).count()}

    @expose
    def write(self, restart=True):
        shutil.copy(self.template, self.path)
        with open(self.path, 'a') as f:
            f.write('\n')
            for frontend in self.session.query(Frontend).options(joinedload('*')).all():
                f.write('frontend %s\n' %frontend.name)
                f.write('\tbind %s\n' % frontend.binds)
                if frontend.options:
                    for option in frontend.options.split(','):
                        f.write('\t%s\n' % option.strip())
                if frontend.associations:
                    for association in frontend.associations:
                        f.write('\tuse_backend %s %s\n' % (association.backend.name, association.condition))
                if frontend.default_backend_id:
                    f.write('\tdefault_backend %s\n' % frontend.default_backend.name)
                f.write('\n')
            for backend in self.session.query(Backend).all():
                f.write('backend %s\n' % backend.name)
                if backend.options:
                    for option in backend.options.split(','):
                        f.write('\t%s\n' % option.strip())
                for server in backend.servers.split(','):
                    f.write('\tserver %s\n' % server.strip())
                f.write('\n')
        error = self.check()
        if error:
            return {'success': False, 'error': error}
        if restart:
            self.restart()
        return {'success': True}

    def status(self):
        with open(os.devnull, 'w') as devnull:
            running = not subprocess.call([self.start_stop_status, 'status'], stdout=devnull, stderr=devnull)
        if running:
            return 'running'
        return 'stopped'

    def restart(self):
        with open(os.devnull, 'w') as devnull:
            subprocess.call([self.start_stop_status, 'stop'], stdout=devnull, stderr=devnull)
            subprocess.call([self.start_stop_status, 'start'], stdout=devnull, stderr=devnull)

    def check(self):
        with open(os.devnull, 'w') as devnull:
            error = subprocess.check_output([self.start_stop_status, 'check'], stderr=subprocess.STDOUT)
        return error

    @expose
    def reload(self):
        default_config()
        self.write()
        return {'success': True}


class Frontends(Base):
    def __init__(self):
        self.session = Session()

    @expose(kind=STORE_CUD)
    def create(self, data):
        results = []
        for record in data:
            frontend = Frontend(name=record['name'], binds=record['binds'], default_backend_id=record['default_backend_id'] or None,
                                options=record['options'])
            self.session.add(frontend)
            self.session.commit()
            results.append({'id': frontend.id, 'name': frontend.name, 'binds': frontend.binds, 'default_backend_id': frontend.default_backend.id if frontend.default_backend_id else None,
                            'default_backend_name': frontend.default_backend.name if frontend.default_backend_id else None, 'options': frontend.options})
        return results

    @expose(kind=STORE_READ)
    def read(self):
        results = []
        for frontend in self.session.query(Frontend).all():
            results.append({'id': frontend.id, 'name': frontend.name, 'binds': frontend.binds, 'default_backend_id': frontend.default_backend.id if frontend.default_backend_id else None,
                            'default_backend_name': frontend.default_backend.name if frontend.default_backend_id else None, 'options': frontend.options})
        return results

    @expose(kind=STORE_CUD)
    def update(self, data):
        results = []
        for record in data:
            frontend = self.session.query(Frontend).get(record['id'])
            frontend.name = record['name']
            frontend.binds = record['binds']
            frontend.default_backend_id = record['default_backend_id'] or None
            frontend.options = record['options']
            self.session.commit()
            results.append({'id': frontend.id, 'name': frontend.name, 'binds': frontend.binds, 'default_backend_id': frontend.default_backend.id if frontend.default_backend_id else None,
                            'default_backend_name': frontend.default_backend.name if frontend.default_backend_id else None, 'options': frontend.options})
        return results

    @expose(kind=STORE_CUD)
    def destroy(self, data):
        results = []
        for frontend_id in data:
            frontend = self.session.query(Frontend).get(frontend_id)
            self.session.delete(frontend)
            results.append(frontend.id)
        self.session.commit()
        return results


class Backends(Base):
    def __init__(self):
        self.session = Session()

    @expose(kind=STORE_CUD)
    def create(self, data):
        results = []
        for record in data:
            backend = Backend(name=record['name'], servers=record['servers'], options=record['options'])
            self.session.add(backend)
            self.session.commit()
            results.append({'id': backend.id, 'name': backend.name, 'servers': backend.servers, 'options': backend.options})
        return results

    @expose(kind=STORE_READ)
    def read(self):
        results = []
        for backend in self.session.query(Backend).all():
            results.append({'id': backend.id, 'name': backend.name, 'servers': backend.servers, 'options': backend.options})
        return results

    @expose(kind=STORE_CUD)
    def update(self, data):
        results = []
        for record in data:
            backend = self.session.query(Backend).get(record['id'])
            backend.name = record['name']
            backend.servers = record['servers']
            backend.options = record['options']
            results.append({'id': backend.id, 'name': backend.name, 'servers': backend.servers, 'options': backend.options})
        self.session.commit()
        return results

    @expose(kind=STORE_CUD)
    def destroy(self, data):
        results = []
        for backend_id in data:
            backend = self.session.query(Backend).get(backend_id)
            self.session.delete(backend)
            results.append(backend.id)
        self.session.commit()
        return results


class Associations(Base):
    def __init__(self):
        self.session = Session()

    @expose(kind=STORE_CUD)
    def create(self, data):
        results = []
        for record in data:
            association = Association(frontend_id=record['frontend_id'], backend_id=record['backend_id'], condition=record['condition'])
            self.session.add(association)
            self.session.commit()
            results.append({'id': '%d-%d' % (association.frontend_id, association.backend_id),
                            'frontend_id': association.frontend_id, 'backend_id': association.backend_id, 
                            'frontend_name': association.frontend.name, 'backend_name': association.backend.name,
                            'condition': association.condition})
        return results

    @expose(kind=STORE_CUD)
    def update(self, data):
        results = []
        for record in data:
            association = self.session.query(Association).get(tuple(record['id'].split('-')))
            association.frontend_id = record['frontend_id']
            association.backend_id = record['backend_id']
            association.condition = record['condition']
            results.append({'id': '%d-%d' % (association.frontend_id, association.backend_id),
                            'frontend_id': association.frontend_id, 'backend_id': association.backend_id, 
                            'frontend_name': association.frontend.name, 'backend_name': association.backend.name,
                            'condition': association.condition})
        self.session.commit()
        return results

    @expose(kind=STORE_READ)
    def read(self):
        results = []
        for association in self.session.query(Association).all():
            results.append({'id': '%d-%d' % (association.frontend_id, association.backend_id),
                            'frontend_id': association.frontend_id, 'backend_id': association.backend_id, 
                            'frontend_name': association.frontend.name, 'backend_name': association.backend.name,
                            'condition': association.condition})
        return results

    @expose(kind=STORE_CUD)
    def destroy(self, data):
        results = []
        for association_id in data:
            association = self.session.query(Association).get(tuple(association_id.split('-')))
            self.session.delete(association)
            results.append(association_id)
        self.session.commit()
        return results


def notify(message):
    with open(os.devnull, 'w') as devnull:
        subprocess.call(['synodsmnotify', '@administrators', 'HAProxy', message], stdin=devnull, stdout=devnull, stderr=devnull)

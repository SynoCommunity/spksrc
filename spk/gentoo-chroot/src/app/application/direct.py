from pyextdirect.configuration import create_configuration, expose, LOAD, STORE_READ, STORE_CUD
from pyextdirect.router import Router
import os
import subprocess
from config import *
from db import *


__all__ = ['Base', 'Services', 'Overview']


Base = create_configuration()


class Services(Base):
    def __init__(self):
        self.session = Session()

    @expose(kind=STORE_CUD)
    def create(self, data):
        results = []
        for record in data:
            service = Service(name=record['name'], launch_script=record['launch_script'], status_command=record['status_command'])
            self.session.add(service)
            self.session.commit()
            results.append({'id': service.id, 'name': service.name, 'launch_script': service.launch_script,
                            'status_command': service.status_command, 'status': service.status})
        return results

    @expose(kind=STORE_READ)
    def read(self):
        results = []
        for service in self.session.query(Service).all():
            results.append({'id': service.id, 'name': service.name, 'launch_script': service.launch_script,
                             'status_command': service.status_command, 'status': service.status})
        return results

    @expose(kind=STORE_CUD)
    def update(self, data):
        results = []
        for record in data:
            service = self.session.query(Service).get(record['id'])
            service.name = record['name']
            service.launch_script = record['launch_script']
            service.status_command = record['status_command']
            results.append({'id': service.id, 'name': service.name, 'launch_script': service.launch_script,
                            'status_command': service.status_command, 'status': service.status})
        self.session.commit()
        return results

    @expose(kind=STORE_CUD)
    def destroy(self, data):
        results = []
        for service_id in data:
            service = self.session.query(Service).get(service_id)
            self.session.delete(service)
            results.append({'id': service.id, 'name': service.name, 'launch_script': service.launch_script,
                            'status_command': service.status_command, 'status': service.status})
        self.session.commit()
        return [r['id'] for r in results]

    @expose
    def start(self, service_id):
        service = self.session.query(Service).get(service_id)
        return service.start()

    @expose
    def stop(self, service_id):
        service = self.session.query(Service).get(service_id)
        return service.stop()

    def stop_all(self):
        for service in self.session.query(Service).all():
            if service.status:
                service.stop()

    def start_all(self):
        for service in self.session.query(Service).all():
            if not service.status:
                service.start()

class Overview(Base):
    def __init__(self):
        self.session = Session()

    @expose(kind=LOAD)
    def load(self):
        result = {'installed': 'installed' if self.is_installed() else 'installing',
                  'running_services': self.running_services(),
                  'updates': self.updates_count()}
        return result

    @expose
    def updates_count(self):
        with open(os.devnull, 'w') as devnull:
            updates_count = int(subprocess.check_output(['chroot', chroottarget, '/bin/bash', '-c', 'emerge --update --deep @world --pretend --quiet | grep "U" | wc -l'], stdin=devnull, stderr=devnull, env={'PATH': env_path}))
        return updates_count

    @expose
    def do_refresh(self):
        with open(os.devnull, 'w') as devnull:
            status = not subprocess.call(['chroot', chroottarget, '/bin/bash', '-c', 'emerge --sync --quiet'], stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path})
        if status:
            return self.updates_count()
        return status

    @expose
    def do_update(self):
        with open(os.devnull, 'w') as devnull:
            status = not subprocess.call(['chroot', chroottarget, '/bin/bash', '-c', 'emerge --update --deep @world --quiet'], stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path})
        return status

    def is_installed(self):
        return os.path.exists(installed)

    def running_services(self):
        return len([service for service in self.session.query(Service).all() if service.status == 1])

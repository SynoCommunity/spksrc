from pyextdirect.configuration import create_configuration, expose, LOAD, STORE_READ, STORE_CUD
from pyextdirect.router import Router
import os
import subprocess
import time
from config import *
from db import *


__all__ = ['Base', 'Service', 'Overview']


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
                while service.status:
                    time.sleep(0.8)

    def start_all(self):
        for service in self.session.query(Service).all():
            if not service.status:
                service.start()
                while not service.status:
                    time.sleep(0.8)


def chroot_check_output(cmd):
    with open(os.devnull, 'w') as devnull:
        return subprocess.check_output(['chroot', chroottarget, '/bin/bash', '-c', cmd], stdin=devnull, stderr=devnull, env={'PATH': env_path})

def chroot_call(cmd):
    with open(os.devnull, 'w') as devnull:
        return subprocess.call(['chroot', chroottarget, '/bin/bash', '-c', cmd], stdin=devnull, stderr=devnull, stdout=devnull, env={'PATH': env_path})


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
        return int(chroot_check_output('apt-get --dry-run upgrade | grep ^Inst | wc -l'))

    @expose
    def do_update(self):
        if chroot_call('apt-get update -qq'):
            return self.updates_count()

    @expose
    def do_upgrade(self):
        return not chroot_call('apt-get upgrade -qq -y')

    def is_installed(self):
        return os.path.exists(installed)

    def running_services(self):
        return len([service for service in self.session.query(Service).all() if service.status == 1])

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String
from sqlalchemy.engine import create_engine
from sqlalchemy.orm.session import sessionmaker
import subprocess
import os
from config import *


__all__ = ['Base', 'engine', 'Session', 'Service', 'setup']


Base = declarative_base()
engine = create_engine('sqlite:////usr/local/gentoo-chroot/var/gentoo-chroot.db', echo=False)
Session = sessionmaker(bind=engine)


class Service(Base):
    __tablename__ = 'services'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    launch_script = Column(String)
    status_command = Column(String)

    def start(self):
        with open(os.devnull, 'w') as devnull:
            status = not subprocess.call(['chroot', chroottarget, '/bin/bash', '-c', self.launch_script + ' start'], stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path})
        return status

    def stop(self):
        with open(os.devnull, 'w') as devnull:
            status = not subprocess.call(['chroot', chroottarget, '/bin/bash', '-c', self.launch_script + ' stop'], stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path})
        return status

    @property
    def status(self):
        with open(os.devnull, 'w') as devnull:
            status = not subprocess.call(['chroot', chroottarget, '/bin/bash', '-c', self.status_command], stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path})
        return status


def setup():
    Base.metadata.create_all(engine)

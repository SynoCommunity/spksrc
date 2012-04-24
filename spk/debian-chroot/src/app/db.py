from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String
import subprocess


Base = declarative_base()
engine = create_engine('sqlite:///' + database_path, echo=False)
Session = sessionmaker(bind=engine)
database_path = '/usr/local/debian-chroot/var/debian-chroot.db'
env_path = '/usr/local/debian-chroot/bin:/usr/local/debian-chroot/env/bin:/usr/local/python/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin'


class Sercice(Base):
     __tablename__ = 'services'

     id = Column(Integer, primary_key=True)
     name = Column(String)
     launch_script = Column(String)
     status_command = Column(String)

    def start(self):
        with open(os.devnull, 'w') as devnull:
            subprocess.call(['chroot', '/bin/bash -c \'' + self.launch_script + ' start\'', stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path}])

    def stop(self):
        with open(os.devnull, 'w') as devnull:
            subprocess.call(['chroot', '/bin/bash -c \'' + self.launch_script + ' stop\'', stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path}])

    @property
    def status(self):
        with open(os.devnull, 'w') as devnull:
            status = subprocess.call(['chroot', '/bin/bash -c \'' + self.status_command + '\'', stdin=devnull, stdout=devnull, stderr=devnull, env={'PATH': env_path}])
        return status


def setup():
    Base.metadata.create_all(engine)


from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, Unicode
from sqlalchemy.engine import create_engine
from sqlalchemy.orm.session import sessionmaker
import subprocess
import os


__all__ = ['Base', 'engine', 'Session', 'Directory', 'setup']


Base = declarative_base()
engine = create_engine('sqlite:////usr/local/subliminal/var/subliminal.db', echo=False)
Session = sessionmaker(bind=engine)


class Directory(Base):
    __tablename__ = 'directories'

    id = Column(Integer, primary_key=True)
    name = Column(Unicode)
    path = Column(Unicode)


def setup():
    Base.metadata.create_all(engine)

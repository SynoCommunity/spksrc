# -*- coding: utf-8 -*-
from sqlalchemy import Column, Integer, Unicode, ForeignKey, event
from sqlalchemy.engine import create_engine, Engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm.session import sessionmaker
from sqlalchemy.orm import relationship
import os.path


__all__ = ['Base', 'engine', 'Session', 'Frontend', 'Backend', 'Association', 'setup', 'default_config']


Base = declarative_base()
engine = create_engine(u'sqlite:////usr/local/haproxy/var/haproxy.db', echo=False)
Session = sessionmaker(bind=engine)


@event.listens_for(Engine, "connect")
def set_sqlite_pragma(dbapi_connection, connection_record):
    cursor = dbapi_connection.cursor()
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.close()


class Frontend(Base):
    __tablename__ = 'frontends'

    id = Column(Integer, primary_key=True)
    name = Column(Unicode)
    binds = Column(Unicode)
    default_backend_id = Column(Integer, ForeignKey('backends.id', ondelete='SET NULL'))
    options = Column(Unicode, nullable=False, default='')

    default_backend = relationship('Backend')
    associations = relationship('Association', back_populates='frontend', cascade='all, delete-orphan')


class Backend(Base):
    __tablename__ = 'backends'

    id = Column(Integer, primary_key=True)
    name = Column(Unicode)
    servers = Column(Unicode)
    options = Column(Unicode, nullable=False, default='')

    associations = relationship('Association', back_populates='backend', cascade='all, delete-orphan')


class Association(Base):
    __tablename__ = 'associations'

    frontend_id = Column(Integer, ForeignKey('frontends.id', ondelete='CASCADE'), primary_key=True)
    backend_id = Column(Integer, ForeignKey('backends.id', ondelete='CASCADE'), primary_key=True)
    condition = Column(Unicode, nullable=False, default='')

    frontend = relationship('Frontend', back_populates='associations')
    backend = relationship('Backend', back_populates='associations')


def setup():
    initialize = False
    if not os.path.exists(u'/usr/local/haproxy/var/haproxy.db'):
        initialize = True
    Base.metadata.create_all(engine)
    if initialize:
        default_config()


def default_config():
    session = Session()
    session.query(Frontend).delete()
    session.query(Backend).delete()
    session.add(Backend(id=1, name=u'web', servers=u'web localhost:80'))
    session.add(Backend(id=2, name=u'dsm', servers=u'dsm localhost:5000'))
    session.add(Backend(id=3, name=u'sabnzbd', servers=u'sabnzbd localhost:8080'))
    session.add(Backend(id=4, name=u'nzbget', servers=u'nzbget localhost:6789'))
    session.add(Backend(id=5, name=u'sickbeard', servers=u'sickbeard localhost:8081'))
    session.add(Backend(id=6, name=u'couchpotatoserver', servers=u'couchpotatoserver localhost:5050'))
    session.add(Backend(id=7, name=u'headphones', servers=u'headphones localhost:8181'))
    session.add(Backend(id=8, name=u'maraschino', servers=u'maraschino localhost:8260'))
    session.add(Backend(id=9, name=u'znc', servers=u'znc localhost:8250'))
    session.add(Backend(id=10, name=u'transmission', servers=u'transmission localhost:9091'))
    session.add(Backend(id=11, name=u'gateone', servers=u'gateone localhost:8270'))
    session.add(Frontend(id=1, name=u'http', binds=u':5080', default_backend_id=1))
    session.add(Frontend(id=2, name=u'https', binds=u':5443 ssl crt /usr/local/haproxy/var/crt/default.pem', default_backend_id=1))
    session.add(Association(frontend_id=2, backend_id=2, condition=u'if { hdr_beg(Host) -i dsm. }'))
    session.add(Association(frontend_id=2, backend_id=3, condition=u'if { hdr_beg(Host) -i sabnzbd. }'))
    session.add(Association(frontend_id=2, backend_id=4, condition=u'if { hdr_beg(Host) -i nzbget. }'))
    session.add(Association(frontend_id=2, backend_id=5, condition=u'if { hdr_beg(Host) -i sickbeard. }'))
    session.add(Association(frontend_id=2, backend_id=6, condition=u'if { hdr_beg(Host) -i couchpotatoserver. }'))
    session.add(Association(frontend_id=2, backend_id=7, condition=u'if { hdr_beg(Host) -i headphones. }'))
    session.add(Association(frontend_id=2, backend_id=8, condition=u'if { hdr_beg(Host) -i maraschino. }'))
    session.add(Association(frontend_id=2, backend_id=9, condition=u'if { hdr_beg(Host) -i znc. }'))
    session.add(Association(frontend_id=2, backend_id=10, condition=u'if { hdr_beg(Host) -i transmission. }'))
    session.add(Association(frontend_id=2, backend_id=11, condition=u'if { hdr_beg(Host) -i gateone. }'))
    session.commit()

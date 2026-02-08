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


@event.listens_for(Engine, 'connect')
def set_sqlite_pragma(dbapi_connection, connection_record):
    cursor = dbapi_connection.cursor()
    cursor.execute('PRAGMA foreign_keys=ON')
    cursor.close()


class Frontend(Base):
    __tablename__ = 'frontends'

    id = Column(Integer, primary_key=True)
    name = Column(Unicode)
    binds = Column(Unicode)
    default_backend_id = Column(Integer, ForeignKey('backends.id', ondelete='SET NULL'))
    options = Column(Unicode, nullable=False, default=u'')

    default_backend = relationship('Backend')
    associations = relationship('Association', back_populates='frontend', cascade='all, delete-orphan')


class Backend(Base):
    __tablename__ = 'backends'

    id = Column(Integer, primary_key=True)
    name = Column(Unicode)
    servers = Column(Unicode)
    options = Column(Unicode, nullable=False, default=u'')

    associations = relationship('Association', back_populates='backend', cascade='all, delete-orphan')


class Association(Base):
    __tablename__ = 'associations'

    frontend_id = Column(Integer, ForeignKey('frontends.id', ondelete='CASCADE'), primary_key=True)
    backend_id = Column(Integer, ForeignKey('backends.id', ondelete='CASCADE'), primary_key=True)
    condition = Column(Unicode, nullable=False, default=u'')

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
    session.add(Backend(id=1, name=u'web', servers=u'web localhost:80 check'))
    session.add(Backend(id=2, name=u'dsm', servers=u'dsm localhost:5000 check'))
    session.add(Backend(id=3, name=u'sabnzbd', servers=u'sabnzbd localhost:8080 check'))
    session.add(Backend(id=4, name=u'nzbget', servers=u'nzbget localhost:6789 check'))
    session.add(Backend(id=5, name=u'sickbeard', servers=u'sickbeard localhost:8081 check'))
    session.add(Backend(id=6, name=u'couchpotatoserver', servers=u'couchpotatoserver localhost:5050 check'))
    session.add(Backend(id=7, name=u'headphones', servers=u'headphones localhost:8181 check'))
    session.add(Backend(id=8, name=u'maraschino', servers=u'maraschino localhost:8260 check'))
    session.add(Backend(id=9, name=u'znc', servers=u'znc localhost:8250 check'))
    session.add(Backend(id=10, name=u'transmission', servers=u'transmission localhost:9091 check'))
    session.add(Backend(id=11, name=u'gateone', servers=u'gateone localhost:8271 ssl check verify none'))
    session.add(Backend(id=12, name=u'webdav', servers=u'webdav localhost:5005 check'))
    session.add(Backend(id=13, name=u'audio', servers=u'audio localhost:8800 check'))
    session.add(Backend(id=14, name=u'download', servers=u'download localhost:8000 check'))
    session.add(Backend(id=15, name=u'surveillance', servers=u'surveillance localhost:9900 check'))
    session.add(Backend(id=16, name=u'video', servers=u'video localhost:9007 check'))
    session.add(Backend(id=17, name=u'file', servers=u'file localhost:7000 check'))
    session.add(Backend(id=18, name=u'haproxy', servers=u'haproxy localhost:8280 check'))
    session.add(Backend(id=19, name=u'deluge', servers=u'deluge localhost:8112 check'))
    session.add(Backend(id=20, name=u'sickchill', servers=u'sickchill localhost:8081 check'))
    session.add(Frontend(id=1, name=u'http', binds=u':5080', default_backend_id=1, options=ur'option http-server-close,option forwardfor'))
    session.add(Frontend(id=2, name=u'https', binds=u':5443 ssl crt /usr/local/haproxy/var/crt/default.pem ciphers AESGCM+AES128:AES128:AESGCM+AES256:AES256:RSA+RC4+SHA:!RSA+AES:!CAMELLIA:!aECDH:!3DES:!DSS:!PSK:!SRP:!aNULL no-sslv3', options=ur'option http-server-close,option forwardfor,rspirep ^Location:\ http://(.*)$    Location:\ https://\1, rspadd Strict-Transport-Security:\ max-age=31536000;\ includeSubDomains', default_backend_id=1))
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
    session.add(Association(frontend_id=2, backend_id=12, condition=u'if { hdr_beg(Host) -i webdav. }'))
    session.add(Association(frontend_id=2, backend_id=13, condition=u'if { hdr_beg(Host) -i audio. }'))
    session.add(Association(frontend_id=2, backend_id=14, condition=u'if { hdr_beg(Host) -i download. }'))
    session.add(Association(frontend_id=2, backend_id=15, condition=u'if { hdr_beg(Host) -i surveillance. }'))
    session.add(Association(frontend_id=2, backend_id=16, condition=u'if { hdr_beg(Host) -i video. }'))
    session.add(Association(frontend_id=2, backend_id=17, condition=u'if { hdr_beg(Host) -i file. }'))
    session.add(Association(frontend_id=2, backend_id=18, condition=u'if { hdr_beg(Host) -i haproxy. }'))
    session.add(Association(frontend_id=2, backend_id=19, condition=u'if { hdr_beg(Host) -i deluge. }'))
    session.add(Association(frontend_id=2, backend_id=20, condition=u'if { hdr_beg(Host) -i sickchill. }'))
    session.commit()

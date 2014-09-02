# -*- coding: utf-8 -*-
from db import *
from sqlalchemy import not_


def upgrade():
    session = Session()
    backends = session.query(Backend).\
        filter(Backend.servers.contains(u'ssl')).\
        filter(not_(Backend.servers.contains(u'verify none'))).\
        all()
    print backends
    for backend in backends:
        backend.servers += u' verify none'
    session.commit()


if __name__ == '__main__':
    upgrade()

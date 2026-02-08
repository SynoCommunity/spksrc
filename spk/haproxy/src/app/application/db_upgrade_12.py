# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from sqlalchemy import not_
from db import *
from direct import Configuration


def upgrade():
    config = Configuration()
    session = Session()
    backends = session.query(Backend).\
        filter(Backend.servers.contains('ssl')).\
        filter(not_(Backend.servers.contains('verify none'))).\
        all()
    for backend in backends:
        backend.servers += ' verify none'
    session.commit()
    config.write(restart=False)


if __name__ == '__main__':
    upgrade()

# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from db import *
from direct import Configuration


def upgrade():
    config = Configuration()
    session = Session()
    frontend = session.query(Frontend).\
        filter_by(name='https',
                  binds=':5443 ssl crt /usr/local/haproxy/var/crt/default.pem',
                  options=r'option http-server-close,option forwardfor,rspirep ^Location:\ http://(.*)$ Location:\ https://\1').\
        first()
    if frontend:
        frontend.binds += ' ciphers AESGCM+AES128:AES128:AESGCM+AES256:AES256:RSA+RC4+SHA:!RSA+AES:!CAMELLIA:!aECDH:!3DES:!DSS:!PSK:!SRP:!aNULL no-sslv3'
        frontend.options += r', rspadd Strict-Transport-Security:\ max-age=31536000;\ includeSubDomains'
        session.commit()
        config.write(restart=False)


if __name__ == '__main__':
    upgrade()

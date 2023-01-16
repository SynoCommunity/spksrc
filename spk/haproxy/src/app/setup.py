#!/usr/local/haproxy/env/bin/python
from application import db, direct


if __name__ == '__main__':
    db.setup()
    direct.Configuration().write(False)

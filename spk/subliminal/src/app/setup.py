#!/usr/local/subliminal/env/bin/python
from application import db, direct


if __name__ == '__main__':
    db.setup()
    subliminal = direct.Subliminal()
    subliminal.setup()

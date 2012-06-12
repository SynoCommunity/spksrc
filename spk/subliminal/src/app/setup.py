#!/usr/local/subliminal/env/bin/python
import db
import api


if __name__ == '__main__':
    db.setup()
    subliminal = api.Subliminal()
    subliminal.setup()

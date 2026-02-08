#!/usr/local/gentoo-chroot/env/bin/python
from application.direct import Services


if __name__ == '__main__':
    services = Services()
    services.start_all()

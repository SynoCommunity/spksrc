#!/usr/local/uidevelop/env/bin/python
import os
import re
import shutil
import subprocess
import cgi
import pyaudio
from pyextdirect.configuration import create_configuration, expose, LOAD, SUBMIT, STORE_READ
from pyextdirect.router import Router
from pyextdirect.api import create_api
from pyextdirect.exceptions import FormError


Base = create_configuration()


class UID(Base):
    @expose(kind=LOAD)
    def load(self):
        # Get the value of all form fields and return them
        #test_directory = ... or '/fake/'
        result = {'test_directory': '/fake/'}
        return result

    @expose(kind=SUBMIT)
    def save(self, test_directory=None):
        # Check arguments validity and raise an exception if one or more are invalid
        # here we use our specific extra "myerrors" that is a dict of fields =>
        # error message code to be translated by the client side
        # This is just an example and not implemented in the client side
        errors = {}
        if not os.path.exists(test_directory):
            errors['test_directory'] = 'invalid_directory'
        if errors:
            raise FormError(extra={'myerrors': errors})
        # Do stuff with those valid arguments
        #self.do_stuff()

    @expose(kind=STORE_READ)
    def get_devices(self):
        # This kind of methods is used as a DirectStore for comboboxes on the client side
        # Get something dynamic here, like a list of connected devices or whatever
        #devices = [...]
        return devices


if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    # Instanciate a router around the Base subclasses
    router = Router(Base)
    router.debug = True  # This will add some verbosity when error occurs
    # Transform a CGI request to a valid Router request
    fs = cgi.FieldStorage()
    request = fs.value
    if isinstance(request, list):
        request = dict((mfs.name, mfs.value) for mfs in request)
    # Route the request to the appropriate function, call it and return the ExtDirect valid
    # response
    print router.route(request)


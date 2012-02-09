#!/usr/local/python27/bin/python
import os
import re
import shutil
import subprocess
import cgi
from pyextdirect.configuration import create_configuration, expose, LOAD, SUBMIT
from pyextdirect.router import Router
from pyextdirect.api import create_api
from pyextdirect.exceptions import FormError


Base = create_configuration()


class MPD(Base):
    config_file = '/usr/local/mpd/etc/mpd.conf'
    mpd_sss = '/var/packages/mpd/scripts/start-stop-status'

    @expose(kind=LOAD)
    def load(self):
        return {'music_directory': self.get('music_directory'), 'port_number': self.get('port')}

    @expose(kind=SUBMIT)
    def save(self, music_directory=None, port_number=None):
        errors = {}
        if not os.path.exists(music_directory):
            errors['music_directory'] = 'invalid_directory'
        if errors:
            raise FormError(extra={'myerrors': errors})
        self.replace('music_directory', music_directory)
        self.replace('port', port_number)

    def replace(self, field, value):
        shutil.copyfile(self.config_file, self.config_file + '.bak')
        with open(self.config_file, 'w') as o:
            for line in open(self.config_file + '.bak', 'r'):
                if line.startswith(field):
                    o.write('%s\t\t"%s"\n' % (field, value))
                else:
                    o.write(line)
        os.remove(self.config_file + '.bak')

    def get(self, field):
        for line in open(self.config_file, 'r'):
            if line.startswith(field):
                return re.search(r'\s+"(.*)"$', line).group(1)


if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    router = Router(Base)
    router.debug = True
    fs = cgi.FieldStorage()
    request = fs.value
    if isinstance(request, list):
        request = dict((mfs.name, mfs.value) for mfs in request)
    print router.route(request)


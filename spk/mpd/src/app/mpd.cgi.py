#!/usr/local/python27/bin/python
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


class MPD(Base):
    config_file = '/usr/local/mpd/etc/mpd.conf'

    @expose(kind=LOAD)
    def load(self):
        result = {'music_directory': self.get('music_directory'),
                  'port_number': self.get('port'),
                  'device': self.get('name', 'audio_output')}
        return result

    @expose(kind=SUBMIT)
    def save(self, music_directory=None, port_number=None, device=None):
        errors = {}
        if not os.path.exists(music_directory):
            errors['music_directory'] = 'invalid_directory'
        if errors:
            raise FormError(extra={'myerrors': errors})
        self.replace('music_directory', music_directory)
        self.replace('port', port_number)
        self.replace('name', device, 'audio_output')

    def replace(self, field, value, category=None):
        shutil.copyfile(self.config_file, self.config_file + '.bak')
        with open(self.config_file, 'w') as o:
            line_category = None
            for line in open(self.config_file + '.bak', 'r'):
                if '{' in line:
                    line_category = re.search(r'^(.*)\s+{$', line).group(1)
                elif '}' in line:
                    line_category = None
                elif re.search(r'^\s*' + field, line) and (category is None or line_category == category):
                    spaces = re.search(r'^(\s*)' + field, line).group(1)
                    o.write(spaces + '%s\t\t"%s"\n' % (field, value))
                    continue
                o.write(line)
        os.remove(self.config_file + '.bak')

    def get(self, field, category=None):
        line_category = None
        for line in open(self.config_file, 'r'):
            if '{' in line:
                line_category = re.search(r'^(.*)\s+{$', line).group(1)
            elif '}' in line:
                line_category = None
            elif re.search(r'^\s*' + field, line) and (category is None or line_category == category):
                return re.search(r'\s+"(.*)"$', line).group(1)

    @expose(kind=STORE_READ)
    def get_devices(self):
        devices = []
        pa = pyaudio.PyAudio()
        for i in range(pa.get_device_count()):
            device_infos = pa.get_device_info_by_index(i)
            devices.append({'id': device_infos['index'], 'name': device_infos['name']})
        return devices


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


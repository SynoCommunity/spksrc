#!/usr/local/couchpotato/env/bin/python
import os
import subprocess
import cgi
import configobj
from pyextdirect.configuration import create_configuration, expose, LOAD, SUBMIT
from pyextdirect.router import Router
from pyextdirect.api import create_api


couchpotato_sss = '/var/packages/couchpotato/scripts/start-stop-status'
couchpotato_path = '/usr/local/couchpotato/var/config.ini'
sabnzbd_path = '/usr/local/sabnzbd/var/config.ini'
nzbget_path = ''  #TODO


Base = create_configuration()


class CouchPotatoCfg(Base):
    def __init__(self):
        '''Load available configuration files'''
        self.configs = {'couchpotato': configobj.ConfigObj(couchpotato_path)}
        if os.path.exists(sabnzbd_path):
            self.configs['sabnzbd'] = configobj.ConfigObj(sabnzbd_path)
        if os.path.exists(nzbget_path):
            self.configs['nzbget'] = configobj.ConfigObj(nzbget_path)

    @expose(kind=LOAD)
    def load(self):
        '''Read configuration files to determine current state'''
        configure_for = self.configs['couchpotato']['NZB']['sendto']
        if configure_for not in ['Sabnzbd', 'Nzbget']:
            configure_for = 'nothing'
        return {'configure_for': configure_for}

    @expose(kind=SUBMIT)
    def save(self, configure_for=None):
        '''Change configuration files as requested'''
        if configure_for == 'Sabnzbd' and 'sabnzbd' in self.configs:
            devnull = open(os.devnull, 'w')
            subprocess.call([couchpotato_sss, 'stop'], stdout=devnull, stderr=devnull)
            self.configs['couchpotato']['NZB']['sendto'] = 'Sabnzbd'
            self.configs['couchpotato']['Sabnzbd']['username'] = self.configs['sabnzbd']['misc']['username']
            self.configs['couchpotato']['Sabnzbd']['password'] = self.configs['sabnzbd']['misc']['password']
            self.configs['couchpotato']['Sabnzbd']['apikey'] = self.configs['sabnzbd']['misc']['api_key']
            self.configs['couchpotato']['Sabnzbd']['host'] = 'localhost:' + self.configs['sabnzbd']['misc']['port']
            subprocess.call([couchpotato_sss, 'start'], stdout=devnull, stderr=devnull)
        elif configure_for == 'Nzbget' and 'Nzbget' in self.configs:
            #TODO
            pass

    @expose
    def available_configs(self):
        '''List available configurations'''
        #TODO: Use this to disable radio butons/checkboxes
        return self.configs.keys()


if __name__ == '__main__':
    print 'Content-type: application/json'
    print
    router = Router(Base)
    fs = cgi.FieldStorage()
    request = fs.value
    if isinstance(request, list):
        request = dict((mfs.name, mfs.value) for mfs in request)
    print router.route(request)


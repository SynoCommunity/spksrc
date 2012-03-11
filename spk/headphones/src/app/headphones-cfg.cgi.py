#!/usr/local/headphones/env/bin/python
import os
import subprocess
import cgi
import configobj
from pyextdirect.configuration import create_configuration, expose, LOAD, SUBMIT
from pyextdirect.router import Router
from pyextdirect.api import create_api


headphones_sss = '/var/packages/headphones/scripts/start-stop-status'
headphones_path = '/usr/local/headphones/var/config.ini'
sabnzbd_path = '/usr/local/sabnzbd/var/config.ini'
nzbget_path = ''  #TODO


Base = create_configuration()

#TODO: Improve when Headphones supports multiple NZB methods
class HeadphonesCfg(Base):
    def __init__(self):
        '''Load available configuration files'''
        self.configs = {'headphones': configobj.ConfigObj(headphones_path)}
        if os.path.exists(sabnzbd_path):
            self.configs['sabnzbd'] = configobj.ConfigObj(sabnzbd_path)
        if os.path.exists(nzbget_path):
            self.configs['nzbget'] = configobj.ConfigObj(nzbget_path)

    @expose(kind=LOAD)
    def load(self):
        '''Read configuration files to determine current state'''
        #FIXME
        return {'configure_for': 'SABnzbd'}
        configure_for = self.configs['headphones']['NZB']['sendto']
        if configure_for not in ['NZBGet', 'NZBGet']:
            configure_for = 'nothing'
        return {'configure_for': configure_for}

    @expose(kind=SUBMIT)
    def save(self, configure_for=None):
        '''Change configuration files as requested'''
        if configure_for == 'SABnzbd' and 'sabnzbd' in self.configs:
            devnull = open(os.devnull, 'w')
            subprocess.call([headphones_sss, 'stop'], stdout=devnull, stderr=devnull)
            self.configs['headphones']['SABnzbd']['sab_username'] = self.configs['sabnzbd']['misc']['username']
            self.configs['headphones']['SABnzbd']['sab_password'] = self.configs['sabnzbd']['misc']['password']
            self.configs['headphones']['SABnzbd']['sab_apikey'] = self.configs['sabnzbd']['misc']['api_key']
            self.configs['headphones']['SABnzbd']['sab_host'] = 'http://localhost:' + self.configs['sabnzbd']['misc']['port']
            self.configs['headphones'].write()
            subprocess.call([headphones_sss, 'start'], stdout=devnull, stderr=devnull)
        elif configure_for == 'NZBGet' and 'nzbget' in self.configs:
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


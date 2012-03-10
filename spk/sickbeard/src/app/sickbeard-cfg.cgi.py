#!/usr/local/sickbeard/env/bin/python
import os
import subprocess
import cgi
import configobj
from pyextdirect.configuration import create_configuration, expose, LOAD, SUBMIT
from pyextdirect.router import Router
from pyextdirect.api import create_api


sickbeard_sss = '/var/packages/sickbeard/scripts/start-stop-status'
sickbeard_path = '/usr/local/sickbeard/var/config.ini'
autoprocesstv_path = '/usr/local/sickbeard/share/SickBeard/autoProcessTV/autoProcessTV.cfg'
sabnzbd_path = '/usr/local/sabnzbd/var/config.ini'
nzbget_path = ''  #TODO


Base = create_configuration()


class SickBeardCfg(Base):
    def __init__(self):
        '''Load available configuration files'''
        self.configs = {'sickbeard': configobj.ConfigObj(sickbeard_path),
                        'autoprocesstv': configobj.ConfigObj(autoprocesstv_path)}
        if os.path.exists(sabnzbd_path):
            self.configs['sabnzbd'] = configobj.ConfigObj(sabnzbd_path)
        if os.path.exists(nzbget_path):
            self.configs['nzbget'] = configobj.ConfigObj(nzbget_path)

    @expose(kind=LOAD)
    def load(self):
        '''Read configuration files to determine current state'''
        autoprocesstv = False
        configure_for = self.configs['sickbeard']['General']['nzb_method']
        if 'sabnzbd' in self.configs and self.configs['sabnzbd']['misc']['script_dir'] == os.path.dirname(autoprocesstv_path):
            autoprocesstv = True
        if configure_for not in ['sabnzbd', 'nzbget']:
            configure_for = 'nothing'
        return {'configure_for': configure_for, 'autoprocesstv': autoprocesstv}

    @expose(kind=SUBMIT)
    def save(self, configure_for=None, autoprocesstv=None):
        '''Change configuration files as requested'''
        if configure_for == 'sabnzbd' and 'sabnzbd' in self.configs:
            devnull = open(os.devnull, 'w')
            subprocess.call([sickbeard_sss, 'stop'], stdout=devnull, stderr=devnull)
            self.configs['sickbeard']['General']['nzb_method'] = 'sabnzbd'
            self.configs['sickbeard']['SABnzbd']['sab_username'] = self.configs['sabnzbd']['misc']['username']
            self.configs['sickbeard']['SABnzbd']['sab_password'] = self.configs['sabnzbd']['misc']['password']
            self.configs['sickbeard']['SABnzbd']['sab_apikey'] = self.configs['sabnzbd']['misc']['api_key']
            self.configs['sickbeard']['SABnzbd']['sab_host'] = 'http://localhost:' + self.configs['sabnzbd']['misc']['port'] + '/'
            self.configs['sickbeard'].write()
            subprocess.call([sickbeard_sss, 'start'], stdout=devnull, stderr=devnull)
        elif configure_for == 'nzbget' and 'nzbget' in self.configs:
            #TODO
            pass
        if autoprocesstv and 'sabnzbd' in self.configs:
            self.configs['sabnzbd']['misc']['script_dir'] = os.path.dirname(autoprocesstv_path)
            self.configs['sabnzbd'].write()

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


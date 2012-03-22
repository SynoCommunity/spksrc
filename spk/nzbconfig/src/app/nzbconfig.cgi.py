#!/usr/local/nzbconfig/env/bin/python
import os
import subprocess
import pwd
import cgi
import configobj
from pyextdirect.configuration import create_configuration, expose, LOAD, SUBMIT
from pyextdirect.router import Router


Base = create_configuration()


SABNZBD, NZBGET, UNDEFINED = range(3)


class SABnzbd(Base):
    config_path = '/usr/local/sabnzbd/var/config.ini'
    sickbeard_postprocessing_dir = '/usr/local/sickbeard/share/SickBeard/autoProcessTV'
    sickbeard_postprocessing_filenames = ['sabToSickBeard.py', 'autoProcessTV.cfg', 'autoProcessTV.py']

    def __init__(self):
        self.config = None
        if os.path.exists(self.config_path):
            self.config = configobj.ConfigObj(self.config_path)

    @expose
    def is_installed(self):
        return self.config is not None

    @expose(kind=LOAD)
    def load(self):
        if self.config is None:
            return None
        return {'sickbeard_postprocessing': self.sickbeard_postprocessing_configured()}

    @expose(kind=SUBMIT)
    def save(self, sickbeard_postprocessing=None):
        if sickbeard_postprocessing:
            self.sickbeard_postprocessing_enable()
            return
        self.sickbeard_postprocessing_disable()

    def sickbeard_postprocessing_configured(self):
        script_dir = self.config['misc']['script_dir']
        configured = True
        for filename in self.sickbeard_postprocessing_filenames:
            configured = configured and os.path.exists(os.path.join(script_dir, filename))
        return configured

    def sickbeard_postprocessing_disable(self):
        script_dir = self.config['misc']['script_dir']
        for filename in self.sickbeard_postprocessing_filenames:
            if not os.path.islink(os.path.join(script_dir, filename)):
                continue
            os.remove(os.path.join(script_dir, filename))

    def sickbeard_postprocessing_enable(self):
        self.sickbeard_postprocessing_disable()
        script_dir = self.config['misc']['script_dir']
        for filename in self.sickbeard_postprocessing_filenames:
            if os.path.exists(os.path.join(script_dir, filename)):
                continue
            os.symlink(os.path.join(self.sickbeard_postprocessing_dir, filename), os.path.join(script_dir, filename))


class NZBGet(Base):
    config_path = '/usr/local/nzbget/var/config.ini'

    def __init__(self):
        self.config = None
        if os.path.exists(self.config_path):
            self.config = configobj.ConfigObj(self.config_path)

    @expose
    def is_installed(self):
        return self.config is not None


class SickBeard(Base):
    config_path = '/usr/local/sickbeard/var/config.ini'
    start_stop_status = '/var/packages/sickbeard/scripts/start-stop-status'
    autoprocesstv_path = '/usr/local/sickbeard/share/SickBeard/autoProcessTV/autoProcessTV.cfg'

    def __init__(self):
        self.config = None
        if os.path.exists(self.config_path):
            self.config = configobj.ConfigObj(self.config_path)

    @expose
    def is_installed(self):
        return self.config is not None

    @expose(kind=LOAD)
    def load(self):
        if self.config is None:
            return None
        configured_for = self.configured_for()
        if configured_for == SABNZBD:
            return {'configure_for': 'sabnzbd'}
        if configured_for == NZBGET:
            return {'configure_for': 'nzbget'}
        return {'configure_for': 'nochange'}

    @expose(kind=SUBMIT)
    def save(self, configure_for=None):
        devnull = open(os.devnull, 'w')
        if configure_for == 'sabnzbd':
            sabnzbd = SABnzbd()
            subprocess.call([self.start_stop_status, 'stop'], stdout=devnull, stderr=devnull)
            # Edit SickBeard's configuration to point to SABnzbd
            self.config['General']['nzb_method'] = 'sabnzbd'
            self.config['SABnzbd']['sab_username'] = sabnzbd.config['misc']['username']
            self.config['SABnzbd']['sab_password'] = sabnzbd.config['misc']['password']
            self.config['SABnzbd']['sab_apikey'] = sabnzbd.config['misc']['api_key']
            self.config['SABnzbd']['sab_host'] = 'http://localhost:' + sabnzbd.config['misc']['port'] + '/'
            self.config.write()
            # Change ownership of autoProcessTV so SABnzbd doesn't fail opening it during postprocessing
            os.chown(self.autoprocesstv_path, pwd.getpwnam('sabnzbd')[2], -1)
            subprocess.call([self.start_stop_status, 'start'], stdout=devnull, stderr=devnull)
            return
        if configure_for == 'nzbget':
            nzbget = NZBGet()
            #TODO
            pass

    def configured_for(self):
        sabnzbd = SABnzbd()
        if (sabnzbd.is_installed() and self.config['General']['nzb_method'] == 'sabnzbd' and self.config['SABnzbd']['sab_username'] == sabnzbd.config['misc']['username'] and
            self.config['SABnzbd']['sab_password'] == sabnzbd.config['misc']['password'] and self.config['SABnzbd']['sab_apikey'] == sabnzbd.config['misc']['api_key'] and
            self.config['SABnzbd']['sab_host'] == 'http://localhost:' + sabnzbd.config['misc']['port'] + '/'):
            return SABNZBD
        if nzbget.is_installed() and self.config['General']['nzb_method'] == 'nzbget':
            return NZBGET
        return UNDEFINED


class CouchPotato(Base):
    config_path = '/usr/local/couchpotato/var/config.ini'
    start_stop_status = '/var/packages/couchpotato/scripts/start-stop-status'

    def __init__(self):
        self.config = None
        if os.path.exists(self.config_path):
            self.config = configobj.ConfigObj(self.config_path)

    @expose
    def is_installed(self):
        return self.config is not None

    @expose(kind=LOAD)
    def load(self):
        if self.config is None:
            return None
        configured_for = self.configured_for()
        if configured_for == SABNZBD:
            return {'configure_for': 'sabnzbd'}
        if configured_for == NZBGET:
            return {'configure_for': 'nzbget'}
        return {'configure_for': 'nochange'}

    @expose(kind=SUBMIT)
    def save(self, configure_for=None):
        devnull = open(os.devnull, 'w')
        if configure_for == 'sabnzbd':
            sabnzbd = SABnzbd()
            subprocess.call([self.start_stop_status, 'stop'], stdout=devnull, stderr=devnull)
            # Edit Couchpotato's configuration to point to SABnzbd
            self.config['NZB']['sendto'] = 'Sabnzbd'
            self.config['Sabnzbd']['username'] = sabnzbd.config['misc']['username']
            self.config['Sabnzbd']['password'] = sabnzbd.config['misc']['password']
            self.config['Sabnzbd']['apikey'] = sabnzbd.config['misc']['api_key']
            self.config['Sabnzbd']['host'] = 'localhost:' + sabnzbd.config['misc']['port']
            self.config.write()
            subprocess.call([self.start_stop_status, 'start'], stdout=devnull, stderr=devnull)
            return
        if configure_for == 'nzbget':
            nzbget = NZBGet()
            #TODO
            pass

    def configured_for(self):
        sabnzbd = SABnzbd()
        if (sabnzbd.is_installed() and self.config['NZB']['sendto'] == 'Sabnzbd' and self.config['Sabnzbd']['username'] == sabnzbd.config['misc']['username'] and
            self.config['Sabnzbd']['password'] == sabnzbd.config['misc']['password'] and self.config['Sabnzbd']['apikey'] == sabnzbd.config['misc']['api_key'] and
            self.config['Sabnzbd']['host'] == 'localhost:' + sabnzbd.config['misc']['port']):
            return SABNZBD
        if nzbget.is_installed() and self.config['NZB']['sendto'] == 'Nzbget':
            return NZBGET
        return UNDEFINED


class Headphones(Base):
    config_path = '/usr/local/headphones/var/config.ini'
    start_stop_status = '/var/packages/headphones/scripts/start-stop-status'

    def __init__(self):
        self.config = None
        if os.path.exists(self.config_path):
            self.config = configobj.ConfigObj(self.config_path)

    @expose
    def is_installed(self):
        return self.config is not None

    @expose(kind=LOAD)
    def load(self):
        if self.config is None:
            return None
        configured_for = self.configured_for()
        if configured_for == SABNZBD:
            return {'configure_for': 'sabnzbd'}
        if configured_for == NZBGET:
            return {'configure_for': 'nzbget'}
        return {'configure_for': 'nochange'}

    @expose(kind=SUBMIT)
    def save(self, configure_for=None):
        devnull = open(os.devnull, 'w')
        if configure_for == 'sabnzbd':
            sabnzbd = SABnzbd()
            subprocess.call([self.start_stop_status, 'stop'], stdout=devnull, stderr=devnull)
            self.config['SABnzbd']['sab_username'] = sabnzbd.config['misc']['username']
            self.config['SABnzbd']['sab_password'] = sabnzbd.config['misc']['password']
            self.config['SABnzbd']['sab_apikey'] = sabnzbd.config['misc']['api_key']
            self.config['SABnzbd']['sab_host'] = 'http://localhost:' + sabnzbd.config['misc']['port']
            self.config.write()
            subprocess.call([self.start_stop_status, 'start'], stdout=devnull, stderr=devnull)
            return
        if configure_for == 'nzbget':
            nzbget = NZBGet()
            #TODO
            pass

    def configured_for(self):
        sabnzbd = SABnzbd()
        if (sabnzbd.is_installed() and self.config['SABnzbd']['sab_username'] == sabnzbd.config['misc']['username'] and
            self.config['SABnzbd']['sab_password'] == sabnzbd.config['misc']['password'] and self.config['SABnzbd']['sab_apikey'] == sabnzbd.config['misc']['api_key'] and
            self.config['SABnzbd']['sab_host'] == 'http://localhost:' + sabnzbd.config['misc']['port']):
            return SABNZBD
        if nzbget.is_installed() and False:
            return NZBGET
        return UNDEFINED


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

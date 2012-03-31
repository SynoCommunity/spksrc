#!/usr/local/nzbconfig/env/bin/python
import os
import tempfile
import shutil
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
    config_path = '/usr/local/nzbget/var/nzbget.conf'
    postprocessing_config_path = '/usr/local/nzbget/var/postprocess.conf'
    script_dir = '/usr/local/nzbget/var'
    sickbeard_postprocessing_dir = '/usr/local/sickbeard/share/SickBeard/autoProcessTV'
    sickbeard_postprocessing_filenames = ['sabToSickBeard.py', 'autoProcessTV.cfg', 'autoProcessTV.py']

    def __init__(self):
        self.config = None
        if os.path.exists(self.config_path):
            self.config = configobj.ConfigObj(self.config_path)
        self.postprocessing_config = None
        if os.path.exists(self.postprocessing_config_path):
            self.postprocessing_config = configobj.ConfigObj(self.postprocessing_config_path)
        self.sickbeard = SickBeard()

    @expose
    def is_installed(self):
        return self.config is not None and self.postprocessing_config is not None

    @expose(kind=LOAD)
    def load(self):
        if self.config is None or self.postprocessing_config is None:
            return None
        return {'sickbeard_postprocessing': self.sickbeard_postprocessing_configured()}

    @expose(kind=SUBMIT)
    def save(self, sickbeard_postprocessing=None):
        if sickbeard_postprocessing:
            self.sickbeard_postprocessing_enable()
            return
        self.sickbeard_postprocessing_disable()

    def fix_config(self, path):
        replace(path, ' = ', '=')
        replace(path, '=""', '=')

    def sickbeard_postprocessing_configured(self):
        configured = (self.postprocessing_config['SickBeard'] == 'yes' and
                      self.postprocessing_config['SickBeardCategory'] == self.sickbeard.config['NZBget']['nzbget_category'])
        for filename in self.sickbeard_postprocessing_filenames:
            configured = configured and os.path.exists(os.path.join(self.script_dir, filename))
        return configured

    def sickbeard_postprocessing_disable(self):
        for filename in self.sickbeard_postprocessing_filenames:
            if not os.path.islink(os.path.join(self.script_dir, filename)):
                continue
            os.remove(os.path.join(self.script_dir, filename))
        self.postprocessing_config['SickBeard'] = 'no'
        self.postprocessing_config.write()
        self.fix_config(self.postprocessing_config_path)

    def sickbeard_postprocessing_enable(self):
        self.sickbeard_postprocessing_disable()
        for filename in self.sickbeard_postprocessing_filenames:
            if os.path.exists(os.path.join(self.script_dir, filename)):
                continue
            os.symlink(os.path.join(self.sickbeard_postprocessing_dir, filename), os.path.join(self.script_dir, filename))
        self.postprocessing_config['SickBeard'] = 'yes'
        self.postprocessing_config['SickBeardCategory'] = self.sickbeard.config['NZBget']['nzbget_category']
        self.postprocessing_config.write()
        self.fix_config(self.postprocessing_config_path)


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
        subprocess.call([self.start_stop_status, 'stop'], stdout=devnull, stderr=devnull)
        if configure_for == 'sabnzbd':
            sabnzbd = SABnzbd()
            self.config['General']['nzb_method'] = 'sabnzbd'
            self.config['SABnzbd']['sab_username'] = sabnzbd.config['misc']['username']
            self.config['SABnzbd']['sab_password'] = sabnzbd.config['misc']['password']
            self.config['SABnzbd']['sab_apikey'] = sabnzbd.config['misc']['api_key']
            self.config['SABnzbd']['sab_host'] = 'http://localhost:' + sabnzbd.config['misc']['port'] + '/'
            os.chown(self.autoprocesstv_path, pwd.getpwnam('sabnzbd')[2], -1)
            return
        if configure_for == 'nzbget':
            nzbget = NZBGet()
            self.config['General']['nzb_method'] = 'nzbget'
            self.config['NZBget']['nzbget_password'] = nzbget.config['ServerPassword']
            self.config['NZBget']['nzbget_host'] = 'localhost:' + nzbget.config['ServerPort']
            os.chown(self.autoprocesstv_path, pwd.getpwnam('nzbget')[2], -1)
        self.config.write()
        subprocess.call([self.start_stop_status, 'start'], stdout=devnull, stderr=devnull)

    def configured_for(self):
        sabnzbd = SABnzbd()
        nzbget = NZBGet()
        if (sabnzbd.is_installed() and self.config['General']['nzb_method'] == 'sabnzbd' and self.config['SABnzbd']['sab_username'] == sabnzbd.config['misc']['username'] and
            self.config['SABnzbd']['sab_password'] == sabnzbd.config['misc']['password'] and self.config['SABnzbd']['sab_apikey'] == sabnzbd.config['misc']['api_key'] and
            self.config['SABnzbd']['sab_host'] == 'http://localhost:' + sabnzbd.config['misc']['port'] + '/'):
            return SABNZBD
        if (nzbget.is_installed() and self.config['General']['nzb_method'] == 'nzbget' and self.config['NZBget']['nzbget_password'] == nzbget.config['ServerPassword'] and
            self.config['NZBget']['nzbget_host'] == 'localhost:' + nzbget.config['ServerPort']):
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
        subprocess.call([self.start_stop_status, 'stop'], stdout=devnull, stderr=devnull)
        if configure_for == 'sabnzbd':
            sabnzbd = SABnzbd()
            self.config['NZB']['sendto'] = 'Sabnzbd'
            self.config['Sabnzbd']['username'] = sabnzbd.config['misc']['username']
            self.config['Sabnzbd']['password'] = sabnzbd.config['misc']['password']
            self.config['Sabnzbd']['apikey'] = sabnzbd.config['misc']['api_key']
            self.config['Sabnzbd']['host'] = 'localhost:' + sabnzbd.config['misc']['port']
            return
        if configure_for == 'nzbget':
            nzbget = NZBGet()
            self.config['NZB']['sendto'] = 'Nzbget'
            self.config['Nzbget']['password'] = nzbget.config['misc']['ServerPassword']
            self.config['Nzbget']['host'] = 'localhost:' + nzbget.config['ServerPort']
        self.config.write()
        subprocess.call([self.start_stop_status, 'start'], stdout=devnull, stderr=devnull)

    def configured_for(self):
        sabnzbd = SABnzbd()
        nzbget = NZBGet()
        if (sabnzbd.is_installed() and self.config['NZB']['sendto'] == 'Sabnzbd' and self.config['Sabnzbd']['username'] == sabnzbd.config['misc']['username'] and
            self.config['Sabnzbd']['password'] == sabnzbd.config['misc']['password'] and self.config['Sabnzbd']['apikey'] == sabnzbd.config['misc']['api_key'] and
            self.config['Sabnzbd']['host'] == 'localhost:' + sabnzbd.config['misc']['port']):
            return SABNZBD
        if (nzbget.is_installed() and self.config['NZB']['sendto'] == 'Nzbget' and self.config['Nzbget']['password'] == nzbget.config['misc']['ServerPassword'] and
            self.config['Nzbget']['host'] == 'localhost:' + nzbget.config['ServerPort']):
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
        nzbget = NZBGet()
        if (sabnzbd.is_installed() and self.config['SABnzbd']['sab_username'] == sabnzbd.config['misc']['username'] and
            self.config['SABnzbd']['sab_password'] == sabnzbd.config['misc']['password'] and self.config['SABnzbd']['sab_apikey'] == sabnzbd.config['misc']['api_key'] and
            self.config['SABnzbd']['sab_host'] == 'http://localhost:' + sabnzbd.config['misc']['port']):
            return SABNZBD
        if nzbget.is_installed() and False:
            return NZBGET
        return UNDEFINED


def replace(filepath, pattern, subst):
    fh, abs_path = tempfile.mkstemp()
    new_file = open(abs_path, 'w')
    old_file = open(filepath)
    for line in old_file:
        new_file.write(line.replace(pattern, subst))
    new_file.close()
    old_file.close()
    new_file = open(abs_path, 'r')
    old_file = open(filepath, 'w')
    shutil.copyfileobj(new_file, old_file)
    new_file.close()
    os.close(fh)
    old_file.close()
    os.remove(abs_path)


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
